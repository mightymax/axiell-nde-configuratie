# Axiell NDE Configuratie

Dit repsository bevat de configuratie die nodig is om de NDE oplossing van Axiell (via https://data.axiell.com) te laten werken.

## XML Stylsheets (XSLT)
De map `./xslt/schema.org` bevat de XSLT's die worden gebruikt om een Adlib OAI-PMH response om te zetten naar `RDF-XML` op basis de [schema.org](https://schema.org) vocabulaire. Elke Axiell NDE deelnemer heeft een kopie nodig van deze XSLT's in de OAI configuratie. De XSLT's zijn generiek, enkel de klant code ("Q-code") dient per instantie aangepast te worden.

## Configuratie beschikbare deelnemers
In het bestand `customers.json` wordt de lijst bijgehouden met deelnemers aan het Axiell/NDE Linked Data initiatief. Dit JSON bestand dient te valideren aan het JSON Schema in `customers.schema.json`. Voor gebruiekrs van Microsft Visual Studio Code is dit automatisch beschikbaar via een configuratie in `.vscode/settings.json`.

## Logo's
Om ervoor te zorgen dat er een logo wordt gepubliceerd bij een organisatie en de dataset, plaats je 2 logo's in `./logos/` (fictieve namen, gebruik het juiste Q-nummer): 
1. `Q1234-organisatie.png`
2. `Q1234-dataset.png`

De logo's mogen indentiek zijn, maar houdt er rekening mee dat het eerste logo op een blauwe achtergrond staat (en dus een lichte achtergond moet hebben) en het tweede op een witte (en dus een donkere achtergrond moet hebben). Het best kun je een vierkant afbeeldingsbestand maken (`png`) omdat de logo's uiteindelijk in een circkel worden getoond op TriplyDB. Als je een achtergrond kleur moet kiezen: `#1690c6` is Triply blauw, `#172940` is Axiell blauw.

