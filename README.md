# Website Bouw- en Aannemersbedrijf Fennis B.V. — Onderhoudshandleiding

Deze repository bevat de statische website van Bouw- en Aannemersbedrijf Fennis B.V. (Hilversum). Dit document is bedoeld voor toekomstig onderhoud: welke technologie is gebruikt, hoe de site is opgebouwd en hoe je wijzigingen veilig doorvoert.

## 1. Technologieën

- **Geen framework, geen build tools.** De site bestaat uit platte HTML, CSS en JavaScript. Er is geen npm/node, bundler, CMS of server-side code nodig.
- **HTML**: losse `.html`-bestanden per pagina (zie hieronder). Taal: Nederlands (`lang="nl"`).
- **CSS**: één stylesheet [css/style.css](css/style.css) met CSS-variabelen (kleuren, radius, schaduwen, containerbreedte) bovenaan in `:root`. Geen externe CSS-frameworks of CDN's — bewust voor performance en privacy (geen third-party requests, systeem-fontstack i.p.v. Google Fonts).
- **JavaScript**: één klein bestand [js/main.js](js/main.js), zonder dependencies. Regelt alleen:
  - het openen/sluiten van het mobiele navigatiemenu (hamburgerknop);
  - het automatisch invullen van het jaartal in de footer (`#current-year`).
- **Iconen/afbeeldingen**: [assets/images/logo.svg](assets/images/logo.svg) en [assets/images/favicon.svg](assets/images/favicon.svg) zijn eigen, simpele SVG's (monogram). Er zijn bewust géén foto's van de oude site overgenomen (auteursrecht/hotlinking vermijden). Bij het toevoegen van echte projectfoto's: gebruik eigen/aangekocht materiaal en optimaliseer de bestandsgrootte.
- **SEO / vindbaarheid**:
  - [robots.txt](robots.txt) en [sitemap.xml](sitemap.xml) voor zoekmachines.
  - [llms.txt](llms.txt) volgens de llmstxt.org-conventie, een korte samenvatting voor AI-assistenten/LLM's.
  - Op elke pagina: JSON-LD structured data (`GeneralContractor`/`LocalBusiness`), Open Graph-meta, canonical URL. Op [index.html](index.html) en [contact.html](contact.html) bevat de structured data ook een `aggregateRating` (Google-beoordeling, zie punt 3). Bewust géén Twitter Card-tags of Facebook/LinkedIn-specifieke markup.
  - Naast de WhatsApp-link (`wa.me`) staat er nu ook een link naar het Google Bedrijfsprofiel (reviews) in de footer van elke pagina, op [contact.html](contact.html) en bij de testimonials-sectie op [index.html](index.html).
- **Overig**: [site.webmanifest](site.webmanifest) (PWA-manifest voor iconen/themakleur), [404.html](404.html) als foutpagina (met dezelfde header/footer als de overige pagina's), [MARKETING-PLAN.md](MARKETING-PLAN.md) met een lopend actieplan (agent-taken en menselijke acties) voor verdere verbetering van de site.

## 2. Paginastructuur

| Pagina | Inhoud |
|---|---|
| [index.html](index.html) | Homepage: introductie, diensten in het kort, werkwijze, testimonials, FAQ |
| [diensten.html](diensten.html) | Volledig overzicht van alle bouw- en verbouwdiensten, met per dienst een CTA-link naar [contact.html](contact.html) |
| [projecten.html](projecten.html) | Projectcategorieën / voorbeelden van uitgevoerd werk |
| [over-ons.html](over-ons.html) | Bedrijfsgeschiedenis (sinds 1963, inclusief de omzetting naar B.V. in 2026) |
| [contact.html](contact.html) | Adres, telefoon, e-mail, openingstijden, Google-reviewlink en kaart (geen contactformulier, alleen directe contactgegevens) |
| [404.html](404.html) | Foutpagina bij niet-bestaande URL's |

⚠️ **Belangrijk**: er is **geen templating-systeem**. De `<header>` (navigatie) en `<footer>` staan letterlijk gedupliceerd in élk HTML-bestand. Wijzig je het menu, de contactgegevens of de footer, dan moet dat **handmatig in elk bestand** worden aangepast. Zoek bijvoorbeeld met een globale zoekopdracht naar het te wijzigen stukje tekst om geen pagina te missen.

## 3. Bedrijfsgegevens die op de site staan

- Naam: Bouw- en Aannemersbedrijf Fennis B.V. (rechtsvorm: besloten vennootschap)
- Adres: Rozenstraat 82, 1214 BW Hilversum
- Telefoon: 06-53671191
- E-mail: fennisaannemersbedrijf@gmail.com
- Openingstijden: ma&ndash;vr 07:30&ndash;17:00 (zie footer op elke pagina en [contact.html](contact.html))
- Opgericht: 28-01-1963 door F.M. Fennis (destijds eenmanszaak); vanaf 1995 VOF; eigenaar/directeur sinds 2005: Rolf Fennis; in 2026 omgezet naar besloten vennootschap (B.V.) — zie de tijdlijn op [over-ons.html](over-ons.html)
- Lidmaatschap: Bouwend Nederland
- Werkgebied: Hilversum en omgeving (Gooi)
- Google Bedrijfsprofiel: `https://share.google/nWJnzld6kABxqizoN` (5,0 sterren, 4 reviews op moment van schrijven). Link staat in de footer van elke pagina, op [contact.html](contact.html) en bij de testimonials-sectie op [index.html](index.html); rating is verwerkt als `aggregateRating` in de JSON-LD op [index.html](index.html) en [contact.html](contact.html). **Bij een nieuwe/gewijzigde rating**: werk de `aggregateRating`-waarden en de zichtbare sterren-badge op de homepage bij.

De volledige bedrijfsnaam "Bouw- en Aannemersbedrijf Fennis B.V." komt bewust op meerdere plekken voor: de footer op elke pagina, de JSON-LD blokken (`name`/`legalName`) in de `<head>`, `site.webmanifest` en [llms.txt](llms.txt). Paginatitels en `og:title` gebruiken de kortere merknaam "Aannemersbedrijf Fennis" i.v.m. SEO-titellengte. **Bij wijziging van adres, telefoon of e-mail: pas alle plekken aan** (zichtbare tekst, JSON-LD op elke pagina, llms.txt).

✅ Het domein is vastgesteld op `https://www.aannemersbedrijf-fennis.nl/` en verwerkt in canonical links, OG-tags, JSON-LD `url`/`image`, sitemap.xml en robots.txt.

ℹ️ De testimonials-sectie op [index.html](index.html) bevat momenteel placeholder-citaten (duidelijk als zodanig gemarkeerd) totdat er echte klantreviews worden aangeleverd — zie [MARKETING-PLAN.md](MARKETING-PLAN.md).

## 4. Lokaal bekijken / testen

Er is geen build-stap nodig. Open `index.html` direct in een browser, of start voor correcte relatieve paden een simpele lokale server vanuit de projectmap, bijvoorbeeld:

```powershell
# Python (indien geïnstalleerd)
python -m http.server 8000

# of met Node.js (npx, geen installatie nodig)
npx serve .
```

Bezoek daarna `http://localhost:8000`.

## 5. Veelvoorkomende onderhoudstaken

### Tekst/inhoud aanpassen
Zoek de betreffende sectie in het HTML-bestand van de pagina en pas de tekst aan. Er is geen CMS — alle content staat direct in de HTML.

### Navigatie of footer wijzigen
Pas de wijziging toe in **elk** HTML-bestand (header en footer komen in alle 6 pagina's identiek voor). Gebruik zoeken-en-vervangen over alle bestanden om niets te missen.

### Nieuwe pagina toevoegen
1. Kopieer een bestaande pagina (bijv. `contact.html`) als basis voor consistente `<head>`, header en footer.
2. Pas `<title>`, meta-description, canonical URL, OG-tags en JSON-LD aan.
3. Voeg een link naar de nieuwe pagina toe in de navigatie van **alle** pagina's (header) en indien relevant de footer.
4. Voeg de pagina toe aan [sitemap.xml](sitemap.xml) en eventueel [llms.txt](llms.txt).

### Stijl/opmaak aanpassen
Alle styling staat in [css/style.css](css/style.css). Kleuren, afstanden en dergelijke via de CSS-variabelen in `:root` aanpassen werkt site-breed door; sectie-specifieke classes staan verderop in het bestand.

### Afbeeldingen toevoegen/vervangen
Plaats bestanden in `assets/images/`. Gebruik gecomprimeerde formaten (WebP/geoptimaliseerde JPG/PNG of SVG voor iconen) om de site snel te houden. Vergeet niet `width`/`height`-attributen en een beschrijvende `alt`-tekst toe te voegen voor toegankelijkheid en SEO.

### SEO-bestanden actueel houden
Bij toevoegen/verwijderen van pagina's: werk [sitemap.xml](sitemap.xml) bij. Bij grote inhoudelijke wijzigingen (diensten, bedrijfsgegevens): werk ook [llms.txt](llms.txt) en de JSON-LD-blokken bij.

## 6. Publiceren / deployen

Dit is een volledig statische site: alle bestanden kunnen direct naar elke statische hosting (bijv. gewone webhosting, Netlify, GitHub Pages, Vercel static) gekopieerd worden. Er is geen build- of deploy-script aanwezig — controleer bij het opzetten van hosting wel of het definitieve domein overeenkomt met de canonical/OG-URL's (zie punt 3).

## 7. Wat je NIET moet doen

- Geen foto's van de oude/originele website (aannemersbedrijf-fennis.nl) hergebruiken zonder toestemming (copyright/hotlinking-risico).
- Geen build-tools, frameworks of CDN-afhankelijkheden introduceren zonder overleg — de site is bewust lichtgewicht en dependency-vrij gehouden.
