<?xml version="1.0"  encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:adlib="https://data.axiell.com/Axiell/vocabulary/"
>
  <xsl:import href="https://nde-apw.adlibhosting.com/Q623558/xslt/oai/schema.org/generic.xslt"/>
  <xsl:param name="database">thesaurus</xsl:param>
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
    <rdf:RDF>
      <xsl:apply-templates select="." mode="metadata">
        <xsl:with-param name="database" select="$database"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./term.type" mode="ConceptSchema"/>
      <skos:Concept rdf:about="{$baseUri}/{$database}/{@priref}">
        <xsl:apply-templates select="./@created | ./@modification | term.type| term | equivalent_term |
        used_for | scope_note | broader_term.lref | narrower_term.lref | related_term.lref| guid
        | term/value[@lang!='neutral']| equivalent_term/value[@lang!='neutral']| used_for/value[@lang!='neutral']
        | scope_note/value[@lang!='neutral']
        "/>
      </skos:Concept>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="term | term/value">
    <skos:prefLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:value-of select="."/>    
    </skos:prefLabel>
  </xsl:template>

  <xsl:template match="equivalent_term | equivalent_term/value">
    <skos:altLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:value-of select="."/>    
    </skos:altLabel>
  </xsl:template>

  <xsl:template match="used_for | used_for/value">
    <skos:hiddenLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:value-of select="."/>    
    </skos:hiddenLabel>
  </xsl:template>

  <xsl:template match="scope_note | scope_note/value">
    <skos:scopeNote>
      <xsl:apply-templates select="@lang"/>
      <xsl:value-of select="."/>    
    </skos:scopeNote>
  </xsl:template>

  <xsl:template match="broader_term.lref">
    <skos:broader rdf:resource="{$baseUri}/{$database}/{.}"/>
  </xsl:template>
  <xsl:template match="narrower_term.lref">
    <skos:narrower rdf:resource="{$baseUri}/{$database}/{.}"/>
  </xsl:template>
  <xsl:template match="related_term.lref">
    <skos:related rdf:resource="{$baseUri}/{$database}/{.}"/>
  </xsl:template>

  <xsl:template match="record/term.type">
    <skos:inSchema rdf:resource="{$baseUri}/{$database}/{value[@lang='neutral']/text()}"/>
  </xsl:template>

  <xsl:template match="record/term.type" mode="ConceptSchema">
  <skos:ConceptSchema rdf:about="{$baseUri}/{$database}/{value[@lang='neutral']/text()}">
    <xsl:apply-templates select="./value"/>
  </skos:ConceptSchema>
  </xsl:template>

  <xsl:template match="value[@lang='neutral']">
    <skos:notation><xsl:value-of select="."/></skos:notation>
  </xsl:template>

  <xsl:template match="value[@lang!='neutral']">
    <skos:prefLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:value-of select="."/>
    </skos:prefLabel>
  </xsl:template>
</xsl:stylesheet>
