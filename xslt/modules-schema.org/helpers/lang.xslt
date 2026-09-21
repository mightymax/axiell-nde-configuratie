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
    <xsl:template match="@lang">
    <xsl:attribute name="xml:lang">
      <xsl:choose>
        <xsl:when test=". = 0">en</xsl:when>
        <xsl:when test=". = 1">nl</xsl:when>
        <xsl:when test=". = 1">nl</xsl:when>
        <xsl:when test=". = 2">fr</xsl:when>
        <xsl:when test=". = 3">de</xsl:when>
        <xsl:when test=". = 4">ar</xsl:when>
        <xsl:when test=". = 5">it</xsl:when>
        <xsl:when test=". = 6">el</xsl:when>
        <xsl:when test=". = 9">sv</xsl:when>
        <xsl:when test=". = 10">he</xsl:when>
        <xsl:when test=". = 11">da</xsl:when>
        <xsl:when test=". = 14">zh</xsl:when>
        <xsl:otherwise>neutral</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>