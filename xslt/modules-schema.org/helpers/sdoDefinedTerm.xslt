<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:sdo="https://schema.org/">

  <xsl:template name="sdoDefinedTerm">
    <xsl:param name="term"/>
    <xsl:param name="guid"/>
    <sdo:DefinedTerm rdf:about="{$baseUri}/{$guid}">
      <sdo:name>
        <xsl:value-of select="$term" />
      </sdo:name>
      <sdo:inDefinedTermSet rdf:resource="{$baseUri}/vocabulary" />
    </sdo:DefinedTerm>
  </xsl:template>

  <xsl:template name="sdoDefinedTermOther">
    <xsl:param name="URI"/>
    <xsl:param name="term"/>
    <xsl:variable name="uri" select="normalize-space($URI)" />
    <sdo:DefinedTerm rdf:about="{$uri}">
      <sdo:name>
        <xsl:value-of select="$term" />
      </sdo:name>
      <dct:source rdf:resource="https://termennetwerk.netwerkdigitaalerfgoed.nl"/>
    </sdo:DefinedTerm>
  </xsl:template>

</xsl:stylesheet>
