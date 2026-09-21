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


  <xsl:template match="Collection">
    <xsl:if test="collection.name[guid != '']">
      <sdo:isPartOf rdf:resource="{$baseUri}/{translate(collection.name/guid, '-', '')}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Collection" mode="StandAlone">
    <xsl:param name="subject" />
    <xsl:if test="./collection.name/guid != ''">
    <sdo:Collection rdf:about="{$baseUri}/{translate(./collection.name/guid, '-', '')}">
      <sdo:name><xsl:value-of select="./collection.name/collection"/></sdo:name>
      <sdo:hasPart rdf:resource="{$baseUri}/{translate(../guid, '-', '')}"/>
    </sdo:Collection>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>