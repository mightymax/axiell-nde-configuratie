<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:sdo="https://schema.org/">
    <xsl:template match="@priref">
    <!-- Axiell Priref -->
    <sdo:identifier>
      <sdo:PropertyValue rdf:about="{$baseUri}/{translate(../guid, '-', '')}#identifier-priref">
        <sdo:propertyID rdf:resource="https://data.axiell.com/vocabulary#Priref"/>
        <sdo:value rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">
          <xsl:value-of select="."/>
        </sdo:value>
      </sdo:PropertyValue>
    </sdo:identifier>
  </xsl:template>
</xsl:stylesheet>
