<#
.SYNOPSIS
    Finds and (optionally) removes privacy-sensitive metadata from JPEG/PNG images.

.DESCRIPTION
    Scans images for embedded metadata that can leak privacy-sensitive information
    (GPS location, timestamps, device/software info): JPEG APP1 (Exif) and APP13
    (Photoshop/IPTC) segments, and PNG tEXt/zTXt/iTXt/eXIf/tIME chunks.

    Removal is done by cutting the offending byte ranges directly out of the file -
    the compressed JPEG scan data / PNG pixel data is never touched or re-encoded,
    so image quality is unaffected.

    By default the script only reports findings. Pass -Fix to actually strip the
    metadata and overwrite the files in place.

.PARAMETER Path
    Root folder to scan recursively. Defaults to assets/images next to this script.

.PARAMETER Fix
    Strip the flagged metadata and overwrite the files. Without this switch the
    script performs a dry-run report only.

.PARAMETER OutputReport
    Optional path to also write the findings as a CSV file.

.EXAMPLE
    ./scripts/Remove-ImageMetadata.ps1
    Reports which images contain privacy-sensitive metadata, without changing anything.

.EXAMPLE
    ./scripts/Remove-ImageMetadata.ps1 -Fix
    Strips the flagged metadata from all matching images in place.
#>
[CmdletBinding()]
param(
    [string]$Path = (Join-Path $PSScriptRoot '..' 'assets' 'images'),
    [switch]$Fix,
    [string]$OutputReport
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-JpegMetadataSegments {
    param([byte[]]$Bytes)

    $segments = @()
    if ($Bytes.Length -lt 4 -or $Bytes[0] -ne 0xFF -or $Bytes[1] -ne 0xD8) {
        return @{ Segments = $segments; ParseOk = $true }
    }

    $offset = 2
    while ($offset -lt $Bytes.Length - 1) {
        if ($Bytes[$offset] -ne 0xFF) { break }
        $marker = $Bytes[$offset + 1]

        # Markers with no length/payload: TEM and RSTn (RST0-RST7).
        if ($marker -eq 0x01 -or ($marker -ge 0xD0 -and $marker -le 0xD7)) {
            $offset += 2
            continue
        }
        # SOS (start of compressed scan data) or EOI: metadata segments are done.
        if ($marker -eq 0xDA -or $marker -eq 0xD9) { break }
        if ($offset + 3 -ge $Bytes.Length) { break }

        # Cast to [int] before shifting - shifting a [byte] by 8 stays within its own
        # 8-bit width and always yields 0, silently discarding the high byte otherwise.
        $segLength = ([int]$Bytes[$offset + 2] -shl 8) -bor $Bytes[$offset + 3]
        if ($segLength -lt 2) { break } # malformed, avoid infinite loop
        $segTotalLength = 2 + $segLength

        # Safety check: the next byte after this segment must be a new marker (or EOF).
        # If not, our declared length doesn't match the real segment boundary - abort
        # rather than risk cutting into the middle of a segment and corrupting the file.
        $nextOffset = $offset + $segTotalLength
        if ($nextOffset -lt $Bytes.Length -and $Bytes[$nextOffset] -ne 0xFF) {
            return @{ Segments = @(); ParseOk = $false }
        }

        if ($marker -eq 0xE1) {
            # APP1: only flag it when it's actually the Exif identifier (vs e.g. XMP).
            $dataStart = $offset + 4
            if ($dataStart + 4 -le $Bytes.Length -and
                $Bytes[$dataStart] -eq 0x45 -and $Bytes[$dataStart + 1] -eq 0x78 -and
                $Bytes[$dataStart + 2] -eq 0x69 -and $Bytes[$dataStart + 3] -eq 0x66) {
                $segments += [PSCustomObject]@{ Offset = $offset; Length = $segTotalLength; Name = 'APP1/Exif' }
            }
        }
        elseif ($marker -eq 0xED) {
            $segments += [PSCustomObject]@{ Offset = $offset; Length = $segTotalLength; Name = 'APP13/Photoshop-IPTC' }
        }

        $offset += $segTotalLength
    }
    return @{ Segments = $segments; ParseOk = $true }
}

function Get-PngMetadataChunks {
    param([byte[]]$Bytes)

    $chunks = @()
    $signature = [byte[]](0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A)
    if ($Bytes.Length -lt 8) { return $chunks }
    for ($i = 0; $i -lt 8; $i++) {
        if ($Bytes[$i] -ne $signature[$i]) { return $chunks }
    }

    $sensitiveTypes = @('tEXt', 'zTXt', 'iTXt', 'eXIf', 'tIME')
    $offset = 8
    while ($offset + 8 -le $Bytes.Length) {
        $len = ([int]$Bytes[$offset] -shl 24) -bor ([int]$Bytes[$offset + 1] -shl 16) `
            -bor ([int]$Bytes[$offset + 2] -shl 8) -bor [int]$Bytes[$offset + 3]
        if ($len -lt 0 -or $offset + 12 + $len -gt $Bytes.Length) { break } # malformed/truncated (data+CRC must fit), avoid infinite loop

        $type = [System.Text.Encoding]::ASCII.GetString($Bytes, $offset + 4, 4)
        $chunkTotalLength = 12 + $len

        if ($sensitiveTypes -contains $type) {
            $chunks += [PSCustomObject]@{ Offset = $offset; Length = $chunkTotalLength; Name = $type }
        }
        if ($type -eq 'IEND') { break }
        $offset += $chunkTotalLength
    }
    return $chunks
}

function Remove-ByteRanges {
    param([byte[]]$Bytes, [array]$Ranges)

    if ($Ranges.Count -eq 0) { return $Bytes }
    $stream = [System.IO.MemoryStream]::new()
    $prevEnd = 0
    foreach ($range in ($Ranges | Sort-Object Offset)) {
        if ($range.Offset -gt $prevEnd) {
            $stream.Write($Bytes, $prevEnd, $range.Offset - $prevEnd)
        }
        $prevEnd = $range.Offset + $range.Length
    }
    if ($prevEnd -lt $Bytes.Length) {
        $stream.Write($Bytes, $prevEnd, $Bytes.Length - $prevEnd)
    }
    return $stream.ToArray()
}

if (-not (Test-Path $Path)) {
    throw "Path not found: $Path"
}
$rootFullPath = (Resolve-Path $Path).Path
$targetExtensions = '.jpg', '.jpeg', '.png'
$files = Get-ChildItem -Path $rootFullPath -Recurse -File |
    Where-Object { $targetExtensions -contains $_.Extension.ToLowerInvariant() }

# Wrap in @() - a 0- or 1-item foreach result would otherwise collapse to $null/scalar.
$results = @(foreach ($file in $files) {
    # -Path may point directly at a single file, in which case FullName equals rootFullPath.
    $relativePath = if ($file.FullName.Length -gt $rootFullPath.Length) {
        $file.FullName.Substring($rootFullPath.Length + 1)
    } else {
        $file.Name
    }
    $ext = $file.Extension.ToLowerInvariant()
    $status = 'Clean'

    try {
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        # Wrap in @() - PowerShell unrolls an empty array return into $null otherwise.
        $parseOk = $true
        $ranges = @(
            if ($ext -eq '.png') {
                Get-PngMetadataChunks -Bytes $bytes
            } else {
                $result = Get-JpegMetadataSegments -Bytes $bytes
                $parseOk = $result.ParseOk
                $result.Segments
            }
        )
        $bytesRemoved = 0
        if ($ranges.Count -gt 0) {
            $bytesRemoved = ($ranges | Measure-Object -Property Length -Sum).Sum
        }

        if (-not $parseOk) {
            $status = 'Skipped: segment boundary check failed - file left untouched'
        }
        elseif ($ranges.Count -gt 0) {
            if ($Fix) {
                $newBytes = Remove-ByteRanges -Bytes $bytes -Ranges $ranges
                $tempPath = "$($file.FullName).tmp"
                [System.IO.File]::WriteAllBytes($tempPath, $newBytes)
                Move-Item -Path $tempPath -Destination $file.FullName -Force
                $status = 'Fixed'
            }
            else {
                $status = 'Flagged (dry-run)'
            }
        }

        [PSCustomObject]@{
            File          = $relativePath
            Format        = $ext.TrimStart('.').ToUpperInvariant()
            MetadataFound = $parseOk -and $ranges.Count -gt 0
            Segments      = ($ranges | Select-Object -ExpandProperty Name) -join ', '
            BytesRemoved  = $bytesRemoved
            Status        = $status
        }
    }
    catch {
        [PSCustomObject]@{
            File          = $relativePath
            Format        = $ext.TrimStart('.').ToUpperInvariant()
            MetadataFound = $false
            Segments      = ''
            BytesRemoved  = 0
            Status        = "Error: $($_.Exception.Message)"
        }
    }
})

$results | Sort-Object File | Format-Table -AutoSize

$flagged = @($results | Where-Object MetadataFound)
Write-Host ""
Write-Host "Scanned $($results.Count) image(s), $($flagged.Count) with privacy-sensitive metadata." -ForegroundColor Cyan

if ($OutputReport) {
    $results | Export-Csv -Path $OutputReport -NoTypeInformation
    Write-Host "Report written to $OutputReport"
}

if (-not $Fix -and $flagged.Count -gt 0) {
    Write-Host "Dry run only - re-run with -Fix to remove the flagged metadata." -ForegroundColor Yellow
}
