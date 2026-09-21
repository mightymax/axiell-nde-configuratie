# schema.org XSLT mapping

Dit document beschrijft welke Axiell/Adlib-velden door de XSLT's in deze map worden gebruikt en hoe ze naar schema.org/RDF worden gemapped.

De hoofdtransformatie staat in `collect.xslt`. Alleen records met een niet-lege `guid` worden als hoofdobject geëxporteerd. Per record wordt een `sdo:CreativeWork` gemaakt met als URI:

```text
{$baseUri}/{translate(guid, '-', '')}
```

`$baseUri` is afgeleid van de meegegeven ARK-NAAN:

```text
https://n2t.net/ark:/{$ark_naan}
```

Daarnaast worden sommige gekoppelde entiteiten ook als losse RDF-resources uitgegeven, bijvoorbeeld personen, organisaties, plaatsen, collecties, mediaobjecten en termen.

## Hoofdrecord

| Bronveld | Voorwaarde | schema.org/RDF-output | Opmerking |
| --- | --- | --- | --- |
| `record/guid` | Verplicht voor export | `sdo:CreativeWork rdf:about="{$baseUri}/{guid-zonder-streepjes}"` | Records zonder `guid` worden niet verwerkt. |
| `record/@created` | Altijd | `dct:created` met datatype `xsd:dateTime` | Metadata, geen schema.org-property. |
| `record/@modification` | Altijd | `dct:modified` met datatype `xsd:dateTime` | Metadata, geen schema.org-property. |
| `record/@selected` | Alleen als `@selected='true'` | `adlib:selected` met datatype `xsd:boolean` | Axiell-specifieke metadata. |
| `record/@deleted` | Alleen als `@deleted='true'` | `adlib:deleted` met datatype `xsd:boolean` | Let op: de huidige XSLT schrijft hier de waarde van `@selected`, niet `@deleted`. |
| `record/@priref` | Als attribuut aanwezig | `sdo:identifier` als `sdo:PropertyValue` | URI is `{record-URI}#identifier-priref`; `sdo:propertyID` is `https://data.axiell.com/vocabulary#Priref`; `sdo:value` is `xsd:integer`. |
| `PIDwork/PID_work_URI` | Als veld aanwezig | `sdo:identifier` als `sdo:PropertyValue` | URI is `{record-URI}#identifier-pid-work-{positie}`; `sdo:propertyID` is `https://www.wikidata.org/wiki/Q420330`; `sdo:value` is `xsd:anyURI`. |

## Beschrijvende velden

| Bronveld | Voorwaarde | schema.org/RDF-output | Opmerking |
| --- | --- | --- | --- |
| `Title/title/value/text()` | Niet leeg | `sdo:name` | Als `Title` zelf een `@lang` heeft, wordt die als `xml:lang` overgenomen. |
| `Title/title/text()` | Niet leeg en geen `title/value` | `sdo:name` | Fallback voor eenvoudige titeltekst. |
| `object_number` | Niet leeg | `sdo:identifier` | Letterlijke identifier van het object. |
| `Description/description/value` | Niet leeg | `sdo:description` | `@lang` op `value` wordt als `xml:lang` overgenomen. |
| `Description/description/text()` | Aanwezig | `sdo:description` | Fallback voor eenvoudige beschrijvingstekst. |
| `related_material.free_text` | Niet leeg | `sdo:hasPart` met geneste `sdo:CreativeWork/sdo:text` | De geneste resource heeft URI `{record-URI}#related-material-{positie}`. |
| `current_location.name` | Niet van toepassing | Geen output | De template voor `sdo:itemLocation` staat in commentaar; standplaatsgegevens worden dus niet gepubliceerd. |

## Vervaardiging en makers

| Bronveld | Voorwaarde | schema.org/RDF-output op hoofdobject | Opmerking |
| --- | --- | --- | --- |
| `Production/creator.role` | Als rol aanwezig | `sdo:creator` met geneste `sdo:Role` | De rol heeft URI `{record-URI}#production-role-{positie}` en krijgt `sdo:name` uit `creator.role/term`. |
| `Production/creator.role/Source/source.number` | Niet leeg | `sdo:Role/sdo:additionalType` | Wordt ook gebruikt als resource in `sdo:Role/sdo:creator`. |
| `Production/creator/guid` | Bij rol aanwezig | `sdo:Role/sdo:creator rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` | Verwijzing naar de maker. |
| PID-velden onder `Production` | Geen rol en PID beschikbaar | `sdo:contributor rdf:resource="{PID-URI}"` | Gezocht wordt naar varianten van `PID_other.URI`, `PID_other_URI`, `PID_data.URI` en `PID_data_URI`, zowel gegroepeerd als direct. |
| `Production/creator/guid` | Geen rol en geen PID | `sdo:contributor rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` | Fallback naar lokale resource. |
| `Production/creator/Source/source.number` | Geen rol, PID of creator-guid | `sdo:contributor rdf:resource="{source.number}"` | Fallback naar externe source URI/identifier. |
| `Production/production.place` PID-velden | PID beschikbaar | `sdo:locationCreated rdf:resource="{PID-URI}"` | Zelfde PID-varianten als hierboven, maar onder `production.place`. |
| `Production/production.place/guid` | Geen plaats-PID en guid niet leeg | `sdo:locationCreated rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` | Fallback naar lokale plaatsresource. |
| `Production/production.place/term` | Geen plaats-PID of guid en term niet leeg | `sdo:locationCreated` naar een record-lokale `sdo:Place` | URI is `{record-URI}#production-place-{positie}`; de plaats krijgt `sdo:name` uit `term`. |

Losse resources voor makers en plaatsen:

| Bronveld | Voorwaarde | Losse RDF-resource | Opmerking |
| --- | --- | --- | --- |
| `Production/creator/name` | Als maker via PID, guid of source wordt uitgegeven | `sdo:Person` of `sdo:Organization` met `sdo:name` | Type wordt bepaald door `name.type/value[@lang='neutral']='INST'`; bij `INST` wordt `sdo:Organization` gebruikt, anders `sdo:Person`. |
| `Production/production.place/term` | Als plaats via PID of guid wordt uitgegeven | `sdo:Place` met `sdo:name` | URI komt uit PID of lokale guid. |

## Datering

`Dating` en `Production_date` worden beide naar `sdo:dateCreated` gemapped.

| Bronveld | Voorwaarde | schema.org/RDF-output | Opmerking |
| --- | --- | --- | --- |
| `Dating/dating.date.start` en `Dating/dating.date.end` | Beide gevuld en gelijk | `sdo:dateCreated` | De datum wordt door `xsdDateParser` getypeerd als `xsd:date`, `xsd:gYearMonth` of `xsd:gYear` als het formaat herkend wordt. |
| `Dating/dating.date.start` en `Dating/dating.date.end` | Beide gevuld en verschillend | `sdo:dateCreated` met waarde `start/end` | Geen datatype. |
| `Dating/dating.date.end` | Alleen einddatum gevuld | `sdo:dateCreated` met waarde `-/end` | Geen datatype. |
| `Dating/dating.date.start` | Alleen startdatum gevuld | `sdo:dateCreated` | Wordt via `xsdDateParser` getypeerd als het formaat herkend wordt. |
| `Production_date/production.date.start` en `Production_date/production.date.end` | Zelfde logica als `Dating` | `sdo:dateCreated` | Bij alleen einddatum wordt `-/end` geschreven. |

Herkende datumformaten in `xsdDateParser`:

| Formaat | Datatype |
| --- | --- |
| `YYYY-MM-DD` | `xsd:date` |
| `YYYY-MM` | `xsd:gYearMonth` |
| `YYYY` | `xsd:gYear` |

## Collecties

| Bronveld | Voorwaarde | schema.org/RDF-output op hoofdobject | Losse RDF-resource |
| --- | --- | --- | --- |
| `Collection/collection.name/guid` | Niet leeg | `sdo:isPartOf rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` | `sdo:Collection rdf:about="{$baseUri}/{guid-zonder-streepjes}"` met `sdo:name` uit `collection.name/collection` en `sdo:hasPart` naar het hoofdobject. |

## Afmetingen

Elke `Dimension` wordt gemapped naar een `sdo:size` met een geneste `sdo:QuantitativeValue`. Deze resource heeft URI `{record-URI}#dimension-{positie}`.

| Bronveld | Voorwaarde | schema.org/RDF-output | Opmerking |
| --- | --- | --- | --- |
| `dimension.type/Source/source.number` | Niet leeg en begint met `http://`, `https://`, `urn:` of `ark:` | `sdo:additionalType rdf:resource="{source.number}"` | Type van de afmeting. |
| `dimension.type/term` | Niet leeg | `sdo:name` | Naam van de afmeting, bijvoorbeeld hoogte of breedte. |
| `dimension.unit/Source/source.number` | Niet leeg en begint met `http://`, `https://`, `urn:` of `ark:` | `sdo:unitCode rdf:resource="{source.number}"` | URI voor de eenheid. |
| `dimension.unit/term` | Niet leeg | `sdo:unitText` | Tekstuele eenheid. |
| `dimension.value` | Niet leeg | `sdo:value` met datatype `xsd:decimal` | Numerieke waarde. |
| `dimension.part` | Aanwezig | `sdo:description` | Beschrijft het onderdeel waarop de afmeting betrekking heeft. |
| `dimension.precision/value[@lang!='neutral']` | Selectie aanwezig | Geen effectieve output | Er is geen specifieke template die deze waarde naar schema.org schrijft. |

## Termen, onderwerpen, materiaal en objectnaam

Deze component behandelt `Associated_subject`, `Content_subject`, `Material` en `Object_name`.

| Bronveld/component | Voorwaarde | schema.org/RDF-output op hoofdobject | Losse RDF-resource |
| --- | --- | --- | --- |
| `Associated_subject` | Externe PID-URI of guid beschikbaar | `sdo:about rdf:resource="{term-URI}"` | `sdo:DefinedTerm` met `sdo:name` uit `.//term`. Zonder URI wordt de term als `sdo:keywords` bewaard. |
| `Content_subject` | Externe PID-URI of guid beschikbaar | `sdo:about rdf:resource="{term-URI}"` | `sdo:DefinedTerm` met `sdo:name` uit `.//term`. Zonder URI wordt de term als `sdo:keywords` bewaard. |
| `Material` | Term niet leeg | `sdo:material` | Met een externe PID of guid wordt een resource gebruikt; anders blijft het materiaal als tekst behouden. |
| `Object_name` | Term niet leeg | `sdo:artform` | Met een externe PID of guid wordt een resource gebruikt; anders blijft de kunstvorm als tekst behouden. Een record met een objectnaam krijgt tevens type `sdo:VisualArtwork`. |

URI-keuze:

| Bronveld | Voorwaarde | URI |
| --- | --- | --- |
| `.//PIDother/PID_other_URI` | Niet leeg en begint met `http://` of `https://` | Externe URI wordt direct gebruikt. |
| `.//guid` | Geen bruikbare externe URI en guid niet leeg | `{$baseUri}/{guid-zonder-streepjes}` |

Losse `sdo:DefinedTerm`-resources met een lokale guid krijgen `sdo:inDefinedTermSet rdf:resource="{$baseUri}/vocabulary"`. Externe termen krijgen `dct:source rdf:resource="https://termennetwerk.netwerkdigitaalerfgoed.nl"`.

## Personen die geassocieerd zijn met of voorkomen in het object

| Bronveld/component | Voorwaarde | schema.org/RDF-output op hoofdobject | Losse RDF-resource |
| --- | --- | --- | --- |
| `Associated_person/association.person/guid` | Niet leeg | `sdo:relatedTo rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` | `foaf:Agent` met `foaf:name` uit `association.person/name`. |
| `Content_person/content.person.name/guid` | Niet leeg | `sdo:relatedTo rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` | `foaf:Agent` met `foaf:name` uit `content.person.name/name`. |

Let op: deze losse persoonresources worden als `foaf:Agent` uitgegeven, niet als `sdo:Person`.

## Gerelateerde objecten

| Bronveld | Voorwaarde | RDF-output op hoofdobject | Losse RDF-resource |
| --- | --- | --- | --- |
| `Related_object/related_object.reference/guid` | Niet leeg | `rdfs:seeAlso rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` | `sdo:Thing rdf:about="{$baseUri}/{guid-zonder-streepjes}"`. |
| `Related_object/related_object.reference/object_number` | Als losse resource wordt gemaakt en objectnummer aanwezig is | - | `sdo:identifier` op de `sdo:Thing`. |

## Media en reproducties

`Media` en `Reproduction` worden gelijk behandeld. Op het hoofdobject komt een verwijzing naar een losse mediaresource.

| Bronveld | Voorwaarde | schema.org/RDF-output op hoofdobject |
| --- | --- | --- |
| `media.reference/guid` of `reproduction.reference/guid` | Niet leeg | `sdo:associatedMedia rdf:resource="{$baseUri}/{guid-zonder-streepjes}"` |

Losse mediaresource:

| Bronveld | Voorwaarde | RDF-output op `sdo:MediaObject` | Opmerking |
| --- | --- | --- | --- |
| `media.reference/guid` of `reproduction.reference/guid` | Altijd in standalone-template | `sdo:MediaObject rdf:about="{$baseUri}/{guid-zonder-streepjes}"` | URI van de mediaresource. |
| `media_type/term` | `digital image` | Extra `rdf:type` `https://schema.org/ImageObject` | Ook gebruikt bij bestandsnamen die eindigen op `.jpg`, `.tif` of `.png`. |
| `media_type/term` | `digital audio` | Extra `rdf:type` `https://schema.org/AudioObject` | Alleen type-aanduiding; geen content-URL. |
| `media_type/term` | `digital video` | Extra `rdf:type` `https://schema.org/VideoObject` | Alleen type-aanduiding; geen content-URL. |
| `media.reference.lref` of `reproduction.reference.lref` | Bij image | `sdo:contentUrl` en `sdo:thumbnailUrl` | IIIF Image API URL op basis van `$customer` en lref. |
| Hoofdrecord `guid` | Bij image | `sdo:isBasedOn rdf:resource="{$baseUri}/{record-guid}/iiif.json"` | Verwijzing naar IIIF Presentation manifest. |
| `$customer` en media-lref | Bij image | `sdo:isBasedOn rdf:resource="https://ndeiiif.adlibhosting.com/iiif/3/{$customer}.{$lref}"` | Verwijzing naar IIIF Image service. |
| `reference_number` | Altijd | `sdo:name` | Naam van het mediaobject. |
| Geen bronveld | Altijd | `sdo:license` met waarde `https://creativecommons.org/licenses/by-sa/4.0/` | Hardcoded in de XSLT. |

Voor image-media worden daarnaast twee `rdf:Description` resources uitgegeven:

| Resource | RDF-output |
| --- | --- |
| `{$baseUri}/{record-guid}/iiif.json` | `sdo:encodingFormat` = `application/ld+json;profile='http://iiif.io/api/presentation/3/context.json'` |
| `https://ndeiiif.adlibhosting.com/iiif/3/{$customer}.{$lref}` | `sdo:encodingFormat` = `application/ld+json;profile='http://iiif.io/api/image/3/context.json'` |

## Rechten

| Bronveld | Voorwaarde | schema.org/RDF-output | Opmerking |
| --- | --- | --- | --- |
| `Rights/rights.type` en `Rights/rights.holder` | `rights.type` niet leeg en holder is niet `Unknown` | `sdo:copyrightNotice` met waarde `rights.type, rights.holder` | Komma en spatie tussen type en houder. |
| `Rights/rights.type` of `Rights/rights.holder` | Een van beide gevuld of holder is niet `Unknown` | `sdo:copyrightNotice` met concatenatie van beide waarden | Geen scheidingsteken in deze fallback. |

## Parameters en URI-patronen

| Parameter | Gebruik |
| --- | --- |
| `customer` | Wordt gebruikt voor IIIF URLs: `https://ndeiiif.adlibhosting.com/iiif/3/{$customer}.{$lref}`. |
| `ark_naan` | Wordt gebruikt om `$baseIdentifier` en `$baseUri` op te bouwen. |
| `baseIdentifier` | `ark:/{$ark_naan}/`; in deze mapping nauwelijks direct gebruikt. |
| `baseUri` | `https://n2t.net/ark:/{$ark_naan}`; basis voor lokale resources. |
| `imageUri` | Gedefinieerd als parameter met default `IMAGEURL`, maar niet gebruikt in de huidige XSLT's. |

## Niet-schema.org namespaces in de output

Naast schema.org worden enkele andere RDF-vocabulaires gebruikt:

| Namespace | Gebruik |
| --- | --- |
| `dct:` | Recordmetadata (`dct:created`, `dct:modified`) en bronvermelding voor externe termen (`dct:source`). |
| `adlib:` | Axiell-specifieke flags `adlib:selected` en `adlib:deleted`. |
| `rdfs:` | `rdfs:seeAlso` voor gerelateerde objecten. |
| `foaf:` | Losse geassocieerde/content-personen als `foaf:Agent` met `foaf:name`. |
| `rdf:` | RDF-structuur, `rdf:about`, `rdf:resource`, `rdf:type` en datatypes. |

## Aandachtspunten in de huidige mapping

- `record/@deleted` schrijft de waarde van `@selected` weg. Als dit niet bedoeld is, moet de template in `generic.xslt` worden aangepast naar `@deleted`.
- `current_location.name` wordt bewust niet gepubliceerd; de template staat in commentaar.
- `dimension.precision/value[@lang!='neutral']` wordt geselecteerd, maar er is geen template die deze waarde daadwerkelijk naar output omzet.
- De helper `lang.xslt` vertaalt numerieke `@lang`-waarden naar taalcode, maar de meeste actieve templates nemen `@lang` letterlijk over in plaats van deze helper toe te passen.
- `urlEncode.xslt` is aanwezig, maar wordt in de huidige schema.org mapping niet aangeroepen.
- De licentie op mediaobjecten is hardcoded als `https://creativecommons.org/licenses/by-sa/4.0/`.
