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

  <xsl:template match="Associated_person | Content_person">
    <xsl:apply-templates select="association.person/guid[text()!=''] | content.person.name/guid[text()!='']" />
  </xsl:template>

  <xsl:template match="association.person/guid | content.person.name/guid">
    <sdo:relatedTo rdf:resource="{$baseUri}/{translate(., '-', '')}" />
  </xsl:template>

  <xsl:template match="Associated_person | Content_person" mode="StandAlone">
    <xsl:apply-templates select="association.person/guid[text()!='']/.. | content.person.name/guid[text()!='']/.." mode="StandAlone" />
  </xsl:template>

  <xsl:template match="association.person | content.person.name" mode="StandAlone">
      <foaf:Agent rdf:about="{$baseUri}/{translate(guid, '-', '')}">
        <foaf:name>
          <xsl:value-of select="name" />
        </foaf:name>
      </foaf:Agent>
  </xsl:template>
</xsl:stylesheet>