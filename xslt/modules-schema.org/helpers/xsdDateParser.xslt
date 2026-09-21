<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
  <xsl:template name="xsdDateParser">
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="translate($value, '0123456789', '##########') = '####-##-##'">
        <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#date</xsl:attribute>
      </xsl:when>
      <xsl:when test="translate($value, '0123456789', '##########') = '####'">
        <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#gYear</xsl:attribute>
      </xsl:when>
      <xsl:when test="translate($value, '0123456789', '##########') = '####-##'">
        <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#gYearMonth</xsl:attribute>
      </xsl:when>
      <xsl:when test="string-length(.)=5 and starts-with(.,'-')">
        <xsl:text>gYear</xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$value"/>
  </xsl:template>
</xsl:stylesheet>