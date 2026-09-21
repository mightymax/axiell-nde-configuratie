<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:sdo="https://schema.org/">

  <xsl:template match="Media | Reproduction">
    <xsl:if test="media.reference[guid!=''] or reproduction.reference[guid!='']">
      <sdo:associatedMedia rdf:resource="{$baseUri}/{translate((media.reference | reproduction.reference)/guid, '-', '')}" />
    </xsl:if>
  </xsl:template>


  <xsl:template match="Media | Reproduction" mode="StandAlone">
    <xsl:variable name="reference" select="media.reference | reproduction.reference" />
    <xsl:variable name="referenceLref" select="media.reference.lref | reproduction.reference.lref" />
    <sdo:MediaObject rdf:about="{$baseUri}/{translate($reference/guid, '-', '')}">
      <xsl:choose>
          <xsl:when test="./media_type/term = 'digital image' 
            or not(normalize-space(./media_type/term))
            or starts-with(./media.reference/format, 'image/')
            or starts-with(./reproduction.reference/format, 'image/')
            or (substring(translate($reference/reference_number, 'JPG', 'jpg'), string-length($reference/reference_number) - 3) = '.jpg')
            or (substring(translate($reference/reference_number, 'TIF', 'tif'), string-length($reference/reference_number) - 3) = '.tif')
            or (substring(translate($reference/reference_number, 'PNG', 'png'), string-length($reference/reference_number) - 3) = '.png')
          ">
          <rdf:type rdf:resource="https://schema.org/ImageObject" />
          <sdo:contentUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
            <xsl:value-of select="concat('https://ndeiiif.adlibhosting.com/iiif/3/', $customer, '.', $referenceLref, '/full/max/0/default.jpg')" />
          </sdo:contentUrl>
          <sdo:thumbnailUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
            <xsl:value-of select="concat('https://ndeiiif.adlibhosting.com/iiif/3/', $customer, '.', $referenceLref, '/full/!250,250/0/default.jpg')" />
          </sdo:thumbnailUrl>
          <sdo:isBasedOn rdf:resource="{$baseUri}/{translate(../guid, '-', '')}/iiif.json" />
            <xsl:choose>
              <xsl:when test="$customer = 'Q4452658'">
                <!-- ANF uitzondering: -->
                <sdo:isBasedOn rdf:resource="https://maior-images.memorix.nl/anf/iiif/{media.reference/reference_number | reproduction.reference/reference_number}" />
              </xsl:when>
              <xsl:otherwise>
                <sdo:isBasedOn rdf:resource="https://ndeiiif.adlibhosting.com/iiif/3/{$customer}.{$referenceLref}"/>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="./media_type/term = 'digital audio'">
          <rdf:type rdf:resource="https://schema.org/AudioObject" />
        </xsl:when>
        <xsl:when test="./media_type/term = 'digital video'">
          <rdf:type rdf:resource="https://schema.org/VideoObject" />
        </xsl:when>
      </xsl:choose>

      <sdo:name>
        <xsl:value-of select="$reference/reference_number" />
      </sdo:name>
      <!-- LET OP: wat doen we hiermee? -->
      <sdo:license rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">https://creativecommons.org/licenses/by-sa/4.0/</sdo:license>
    </sdo:MediaObject>

    <rdf:Description rdf:about="{$baseUri}/{translate(../guid, '-', '')}/iiif.json">
      <sdo:encodingFormat>application/ld+json;profile='http://iiif.io/api/presentation/3/context.json'</sdo:encodingFormat>
    </rdf:Description>
    <rdf:Description rdf:about="https://ndeiiif.adlibhosting.com/iiif/3/{$customer}.{$referenceLref}">
      <sdo:encodingFormat>application/ld+json;profile='http://iiif.io/api/image/3/context.json'</sdo:encodingFormat>
    </rdf:Description>
  </xsl:template>

</xsl:stylesheet>
