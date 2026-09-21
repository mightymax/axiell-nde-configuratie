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
  
  <xsl:template match="Rights">
    <xsl:choose>
      <xsl:when test="rights.type/text() != '' and rights.holder/text() != 'Unknown'">
        <sdo:copyrightNotice>
          <xsl:value-of select="concat(rights.type/text(), ', ', rights.holder/text())" />
        </sdo:copyrightNotice>
      </xsl:when>
      <xsl:when test="rights.type/text() != '' or rights.holder/text() != 'Unknown'">
        <sdo:copyrightNotice>
          <xsl:value-of select="concat(rights.type/text(), rights.holder/text())" />
        </sdo:copyrightNotice>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>