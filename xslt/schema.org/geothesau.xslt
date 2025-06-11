<?xml version="1.0"  encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sdo="https://schema.org/"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
  >
  <xsl:import href="https://nde-apw.adlibhosting.com/Q666/xslt/schema.org/generic.xslt"/>
  <xsl:param name="database">geothesaurus</xsl:param>
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>
  
  <xsl:template match="/adlibXML">
    <xsl:apply-templates select="recordList"/>
  </xsl:template>
  
  <xsl:template match="recordList">
    <recordList>
      <xsl:apply-templates select="record"/>
    </recordList>
  </xsl:template>
  
  <xsl:template match="record">
    <xsl:variable name="id">
      <xsl:value-of select="guid"/>
      <xsl:value-of select="priref[not(../guid!='')]"/>
    </xsl:variable>
    <rdf:RDF>
      <xsl:apply-templates select="./term.type" mode="ConceptSchema"/>
      <sdo:Place rdf:about="{$baseUri}/{$database}/{$id}">
        <xsl:apply-templates select="." mode="metadata">
          <xsl:with-param name="database" select="$database"/>
          <xsl:with-param name="id" select="$id"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*|@*"/>
      </sdo:Place>
      <xsl:apply-templates select="." mode="metadata_identifier_links">
        <xsl:with-param name="id" select="$id"/>
        <xsl:with-param name="database" select="$database"/>
      </xsl:apply-templates>
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template match="term">
    <sdo:name><xsl:value-of select="."/></sdo:name>
  </xsl:template>
  
  <xsl:template match="scope_note">
    <sdo:description><xsl:value-of select="."/></sdo:description>
  </xsl:template>
  
  <xsl:template match="used_for">
    <sdo:alternateName><xsl:value-of select="."/></sdo:alternateName>
  </xsl:template>
  
  <xsl:template match="use.lref">
    <sdo:supersededBy><xsl:value-of select="."/></sdo:supersededBy>
  </xsl:template>
  
  <xsl:template match="term.type">
    <sdo:additionalType rdf:resource="{$baseUri}/{$database}/{value[@lang='neutral']/text()}"/>
  </xsl:template>
  
  <xsl:template match="narrower_term">
    <sdo:containsPlace>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:if test="not(guid)">
          <xsl:text>/thesaurus</xsl:text>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="guid"/>
        <xsl:value-of select="lref[not(../dimension.type/guid!='')]"/>
      </xsl:attribute>
    </sdo:containsPlace>
  </xsl:template>
  
  <xsl:template match="broader_term">
    <sdo:containedInPlace>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:if test="not(guid)">
          <xsl:text>/thesaurus</xsl:text>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="guid"/>
        <xsl:value-of select="lref[not(../dimension.type/guid!='')]"/>
      </xsl:attribute>
    </sdo:containedInPlace>
  </xsl:template>
  
  <xsl:template match="related_term">
    <sdo:seeAlso>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:if test="not(guid)">
          <xsl:text>/thesaurus</xsl:text>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="guid"/>
        <xsl:value-of select="lref[not(../dimension.type/guid!='')]"/>
      </xsl:attribute>
    </sdo:seeAlso>
  </xsl:template>
  
  <xsl:template match="equivalent_term">
    <sdo:sameAs>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:if test="not(guid)">
          <xsl:text>/thesaurus</xsl:text>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="guid"/>
        <xsl:value-of select="lref[not(../dimension.type/guid!='')]"/>
      </xsl:attribute>
    </sdo:sameAs>
  </xsl:template>
  
  
  <xsl:template match="record/term.type" mode="ConceptSchema">
    <skos:ConceptSchema rdf:about="{$baseUri}/{$database}/{value[@lang='neutral']/text()}">
      <xsl:apply-templates select="./value"/>
    </skos:ConceptSchema>
  </xsl:template>
  
  <xsl:template match="GIS">
    <!-- <sdo:geo rdf:datatype="http://www.opengis.net/ont/geosparql#wktLiteral"><xsl:value-of select="normalize-space(.)"/></sdo:geo> -->
    <!-- This is encoded in GeoJSON, it should be transformed to a WKT  -->
    <sdo:geo><xsl:value-of select="normalize-space(.)"/></sdo:geo>
  </xsl:template>
  
  <xsl:template match="value[@lang='neutral']">
    <skos:notation><xsl:value-of select="."/></skos:notation>
  </xsl:template>
  
  <xsl:template match="value[@lang!='neutral']">
    <skos:prefLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:if test="not(@lang!='')"><xsl:attribute name="xml:lang" select="'nl'"/></xsl:if>
      <xsl:value-of select="."/>
    </skos:prefLabel>
  </xsl:template>
  
</xsl:stylesheet>