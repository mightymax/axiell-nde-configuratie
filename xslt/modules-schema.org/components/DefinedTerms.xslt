<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:sdo="https://schema.org/">

  <xsl:template match="Associated_subject | Content_subject | Material | Object_name">
    <xsl:variable name="elementName">
      <xsl:choose>
        <xsl:when test="self::Material">sdo:material</xsl:when>
        <xsl:when test="self::Object_name">sdo:artform</xsl:when>
        <xsl:otherwise>sdo:about</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pidOtherUri" select="normalize-space(.//PIDother/PID_other_URI)" />
    <xsl:variable name="term" select="normalize-space(.//term)" />
    <xsl:choose>
      <xsl:when
        test="$pidOtherUri != '' and (starts-with($pidOtherUri, 'http://') or starts-with($pidOtherUri, 'https://'))">
        <xsl:element name="{$elementName}">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="$pidOtherUri" />
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:when test=".//guid/text() != ''">
        <xsl:element name="{$elementName}">
          <xsl:attribute name="rdf:resource">
            <xsl:value-of select="concat($baseUri, '/', translate(.//guid, '-', ''))" />
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <!-- Schema.org about expects a Thing, so unlinked subject terms are
           preserved as keywords. Material and artform both accept text. -->
      <xsl:when test="$term != '' and (self::Associated_subject or self::Content_subject)">
        <sdo:keywords><xsl:value-of select="$term" /></sdo:keywords>
      </xsl:when>
      <xsl:when test="$term != ''">
        <xsl:element name="{$elementName}">
          <xsl:value-of select="$term" />
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Associated_subject | Content_subject | Material | Object_name"
    mode="StandAlone">

    <xsl:variable name="pidOtherUri" select="normalize-space(.//PIDother/PID_other_URI)" />
    <xsl:choose>
      <xsl:when test="$pidOtherUri != '' and (starts-with($pidOtherUri, 'http://') or starts-with($pidOtherUri, 'https://'))">
        <xsl:call-template name="sdoDefinedTermOther">
          <xsl:with-param name="URI" select="$pidOtherUri" />
          <xsl:with-param name="term" select=".//term" />
        </xsl:call-template>
      </xsl:when>
        <xsl:when test=".//guid/text() != ''">
          <xsl:call-template name="sdoDefinedTerm">
            <xsl:with-param name="guid" select="translate(.//guid, '-', '')" />
            <xsl:with-param name="term" select=".//term" />
          </xsl:call-template>
        </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
