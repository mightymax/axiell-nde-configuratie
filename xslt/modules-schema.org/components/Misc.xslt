<?xml version="1.0" encoding="UTF-8"?>
<!-- Miscellaneous templates, simple transformations -->
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

  <xsl:template match="Title">
    <xsl:choose>
      <xsl:when test="./title/value/text() != ''">
        <sdo:name>
          <xsl:if test="@lang">
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="@lang" />
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="./title/value/text()" />
        </sdo:name>
      </xsl:when>
      <xsl:when test="./title/text() != ''">
        <sdo:name>
          <xsl:value-of select="./title/text()" />
        </sdo:name>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="object_number[text()!='']">
    <sdo:identifier>
      <xsl:value-of select="." />
    </sdo:identifier>
  </xsl:template>

<!-- 
  Standplaatsgegvens niet publiceren!
  <xsl:template match="current_location.name">
    <xsl:if test="name/text() != ''">
      <sdo:itemLocation>
        <xsl:value-of select="name" />
      </sdo:itemLocation>
    </xsl:if>
  </xsl:template>
 -->

  <xsl:template match="related_material.free_text[text()!='']">
    <sdo:hasPart>
      <sdo:CreativeWork rdf:about="{$baseUri}/{translate(ancestor::record[1]/guid, '-', '')}#related-material-{count(preceding-sibling::related_material.free_text) + 1}">
        <sdo:text>
          <xsl:value-of select="." />
        </sdo:text>
      </sdo:CreativeWork>
    </sdo:hasPart>
  </xsl:template>
</xsl:stylesheet>
