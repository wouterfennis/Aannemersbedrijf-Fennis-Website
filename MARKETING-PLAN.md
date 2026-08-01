# Marketingplan — Aannemersbedrijf Fennis website

Gebaseerd op de marketingreview van alle pagina's (16-07-2026). Doel: meer bezoekers laten bellen, mailen of het offerteformulier invullen.

Foto's van projecten en van Rolf Fennis worden later door een mens toegevoegd — zie sectie "Menselijke acties".

---

## 1. Acties voor een coding agent

Deze taken zijn tekst-/code-wijzigingen en kunnen zonder nieuwe foto's worden uitgevoerd.

### Blockers
- [x] **Contactformulier technisch onbetrouwbaar** — [contact.html](contact.html#L165) gebruikt `action="mailto:..." enctype="text/plain"`. *Deels gemitigeerd:* er is nu een zichtbare bevestigingsmelding toegevoegd na verzenden ([js/main.js](js/main.js)) die de verwachtingen bij de bezoeker beter zet. De onderliggende `mailto:`-verzending zelf is **niet** vervangen door een echte serververwerking, omdat dit een account/endpoint bij een formulierdienst vereist (zie menselijke actie "Keuze formulierdienst"). Deze actie moet dus opnieuw opgepakt worden zodra die keuze gemaakt is.
- [x] **Projectenpagina mist tekstuele geloofwaardigheid** — Tekst op [projecten.html](projecten.html#L96) herschreven: benadrukt niet langer het ontbreken van foto's, beschrijft categorieën sterker en meldt neutraal dat foto's "binnenkort" volgen.
- [x] **Geen testimonials/social proof** — Testimonials-sectie met duidelijk gemarkeerde placeholder-citaten toegevoegd op [index.html](index.html).

### Verbeteringen
- [x] **Rolf Fennis niet genoemd op homepage** — Korte verwijzing met link naar [over-ons.html](over-ons.html) toegevoegd aan de intro-sectie van [index.html](index.html).
- [x] **Openingstijden/bereikbaarheid ontbreken volledig** — Openingstijden toegevoegd aan de contactlijst op [contact.html](contact.html) en aan de footer op alle pagina's. *Let op:* de tijden (ma&ndash;vr 07:30&ndash;17:00) zijn een aanname en moeten nog door de klant bevestigd/gecorrigeerd worden (zie menselijke actie).
- [x] **FAQ te beperkt** — 3 vragen toegevoegd aan de FAQ op [index.html](index.html#L242) over garantie/verzekering, eigen personeel/onderaannemers en doorlooptijd. *Let op:* de antwoorden zijn indicatief geformuleerd en moeten nog inhoudelijk geverifieerd worden door de klant.
- [x] **FAQ alleen op homepage** — Verwijzing naar de FAQ toegevoegd op [diensten.html](diensten.html), met een ankerlink (`index.html#faq`) naar de homepage-FAQ.
- [x] **404-pagina onvolledig** — Header (nav, telefoon, WhatsApp, offerte-knop) en volledige footer met contactgegevens toegevoegd aan [404.html](404.html), consistent met de rest van de site.
- [x] **Inconsistente stappen-sectie** — Stappen op [projecten.html](projecten.html#L163) voorzien van dezelfde toelichtende tekst als op [index.html](index.html) en [diensten.html](diensten.html).

### Koppeling met Google Bedrijfsprofiel
Er bestaat een Google Bedrijfsprofiel voor "aannemersbedrijf fennis". De klant heeft de directe deel-link aangeleverd: `https://share.google/nWJnzld6kABxqizoN` (bevestigd als knowledge-graph-ID `/g/1tfwjkt8` voor "Fennis Bouw- en Aannemersbedrijf").
- [x] "Bekijk onze reviews op Google"-link toegevoegd aan de footer op alle 6 pagina's en aan de contactlijst op [contact.html](contact.html#L109).
- [x] Dezelfde Google-link toegevoegd als extra actie onder de testimonials-sectie op [index.html](index.html).
- [x] Vul de JSON-LD structured data (`GeneralContractor`) op [index.html](index.html#L26) en [contact.html](contact.html#L18) aan met een `aggregateRating`-property, zodra het daadwerkelijke gemiddelde en aantal reviews bekend zijn. *Verwerkt: 5,0 sterren op basis van 4 reviews (aangeleverd door de klant). Ook zichtbaar toegevoegd als sterren-badge boven de testimonials-sectie op [index.html](index.html).*
- [ ] Controleer of de NAW-gegevens die al op de site staan (naam, adres, postcode, telefoonnummer — zie footer op alle pagina's) exact overeenkomen met wat op het Google Bedrijfsprofiel staat. *(Kon niet automatisch gecontroleerd worden: Google blokkeerde geautomatiseerde toegang tot de profielpagina met een anti-bot-controle. Dit vereist een handmatige vergelijking door de klant.)*

### Suggesties
- [x] Voeg per dienst-kaart op [diensten.html](diensten.html) een kleine CTA-link toe ("Vraag offerte voor deze dienst").
- [x] Voeg op [contact.html](contact.html) een optioneel keuzeveld toe voor type project (nieuwbouw/verbouw/onderkeldering/anders).

---

## 2. Menselijke acties

Deze acties vereisen input, materiaal of besluiten van de klant/eigenaar en kunnen niet door een agent worden afgerond.

- [x] **Projectfoto's aanleveren** — Minimaal 6-10 foto's van afgeronde/lopende projecten (voor/na waar mogelijk), inclusief de onderkeldering aan de Kapteijnstraat, voor gebruik op [projecten.html](projecten.html) en de homepage. ✅ Verwerkt: kelder-galerij (5 foto's) en verbouwing/dakopbouw-galerij (4 foto's) toegevoegd aan [projecten.html](projecten.html).
- [x] **Portretfoto van Rolf Fennis aanleveren** — Voor gebruik op [over-ons.html](over-ons.html), [contact.html](contact.html) en eventueel de homepage. ✅ Verwerkt: portretfoto toegevoegd aan de directeurskaart op [over-ons.html](over-ons.html) en naast de contactgegevens op [contact.html](contact.html).
- [ ] **Klantreviews/testimonials verzamelen** — Minimaal 2-3 citaten van tevreden opdrachtgevers (met naam/plaats indien akkoord), eventueel aangevuld met een link naar Google Reviews.
- [ ] **Openingstijden en bereikbaarheid doorgeven** — Exacte dagen/tijden waarop gebeld of langsgekomen kan worden.
- [ ] **Garantie- en verzekeringsinformatie aanleveren** — Details over aansprakelijkheidsverzekering, garantietermijnen en of met eigen personeel of onderaannemers wordt gewerkt, t.b.v. de aangevulde FAQ.
- [ ] **Keuze formulierdienst/verwerking contactformulier** — Akkoord geven op welke dienst/aanpak gebruikt mag worden voor het verwerken van formulierinzendingen (i.v.m. eventuele kosten/privacy).
- [x] **Directe link naar Google Bedrijfsprofiel aanleveren** — ~~De gedeelde zoekopdracht is geen directe profiel-link.~~ ✅ Aangeleverd: `https://share.google/nWJnzld6kABxqizoN` — inmiddels verwerkt in de footer, contactpagina en testimonials-sectie.
- [x] **Actuele beoordeling en aantal reviews doorgeven** — ✅ Aangeleverd: 5,0 sterren, 4 reviews. Verwerkt in de `aggregateRating` structured data en als zichtbare sterren-badge op de homepage.
- [ ] **NAW-gegevens op Google Bedrijfsprofiel controleren/corrigeren** — Vergelijk naam, adres, postcode, telefoonnummer en categorie op het Google-profiel met de website en corrigeer afwijkingen in het Google-profiel zelf (dit gebeurt buiten de website). *Kon niet automatisch geverifieerd worden omdat Google geautomatiseerde toegang tot de profielpagina blokkeerde.*
- [ ] **Overwegen van een review-verzoek-strategie** — Bijv. een QR-code of link die na oplevering van een project naar klanten gestuurd wordt om een Google-review achter te laten.
