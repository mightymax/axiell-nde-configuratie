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

  <xsl:template match="Dimension">
    <xsl:variable name="dimensionTypeUri" select="normalize-space(./dimension.type/Source/source.number)" />
    <xsl:variable name="dimensionUnitUri" select="normalize-space(./dimension.unit/Source/source.number)" />
    <sdo:size>
      <sdo:QuantitativeValue rdf:about="{$baseUri}/{translate(ancestor::record[1]/guid, '-', '')}#dimension-{count(preceding-sibling::Dimension) + 1}">
        <xsl:if test="$dimensionTypeUri != '' and (starts-with($dimensionTypeUri, 'http://') or starts-with($dimensionTypeUri, 'https://') or starts-with($dimensionTypeUri, 'urn:') or starts-with($dimensionTypeUri, 'ark:'))">
          <sdo:additionalType rdf:resource="{$dimensionTypeUri}" />
        </xsl:if>
        <xsl:if test="$dimensionUnitUri != '' and (starts-with($dimensionUnitUri, 'http://') or starts-with($dimensionUnitUri, 'https://') or starts-with($dimensionUnitUri, 'urn:') or starts-with($dimensionUnitUri, 'ark:'))">
          <sdo:unitCode rdf:resource="{$dimensionUnitUri}" />
        </xsl:if>
        <xsl:if test="dimension.type/term/text()!=''">
          <sdo:name>
            <xsl:value-of select="dimension.type/term" />
          </sdo:name>
        </xsl:if>
        <xsl:if test="dimension.unit/term/text()!=''">
          <sdo:unitText>
            <xsl:value-of select="dimension.unit/term" />
          </sdo:unitText>
        </xsl:if>
        <xsl:if test="dimension.value!=''">
          <sdo:value rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
            <xsl:value-of select="dimension.value" />
          </sdo:value>
        </xsl:if>
        <xsl:if test="dimension.part">
          <sdo:description>
            <xsl:value-of select="dimension.part" />
          </sdo:description>
        </xsl:if>
        <xsl:apply-templates select="dimension.precision/value[@lang!='neutral']" />
      </sdo:QuantitativeValue>
    </sdo:size>
  </xsl:template>
</xsl:stylesheet>
