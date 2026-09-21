<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:sdo="https://schema.org/"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  
  <xsl:template match="Related_object">
    <xsl:if test="related_object.reference/guid != ''">
      <rdfs:seeAlso rdf:resource="{$baseUri}/{translate(related_object.reference/guid, '-', '')}"/>
    </xsl:if>
  </xsl:template>

    <xsl:template match="Related_object" mode="StandAlone">
      <sdo:Thing rdf:about="{$baseUri}/{translate(related_object.reference/guid, '-', '')}">
        <xsl:if test="./related_object.reference/object_number">
          <sdo:identifier>
            <xsl:value-of select="./related_object.reference/object_number" />
          </sdo:identifier>
        </xsl:if>
      </sdo:Thing>
    </xsl:template>


</xsl:stylesheet>