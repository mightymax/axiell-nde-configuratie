<?xml version="1.0"  encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
                xmlns:sdo="https://schema.org/"
  >
  <xsl:import href="https://nde-apw.adlibhosting.com/Q666/xslt/schema.org/generic.xslt"/>
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
    <xsl:variable name="id">
      <xsl:value-of select="guid"/>
      <xsl:value-of select="priref[not(../guid!='')]"/>
    </xsl:variable>
    <rdf:RDF>
      <xsl:apply-templates select="./term.type" mode="ConceptSchema"/>
      <skos:Concept rdf:about="{$baseUri}/{$id}">
        <xsl:apply-templates select="." mode="metadata">
          <xsl:with-param name="id" select="$id"/>
          <xsl:with-param name="database" select="$database"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="./@created | ./@modification | term.type| term | equivalent_term |
          used_for | scope_note | broader_term | narrower_term | related_term | equivalent_term | guid
          | term/value[@lang!='neutral']| equivalent_term/value[@lang!='neutral']| used_for/value[@lang!='neutral']
          | scope_note/value[@lang!='neutral'] | Source/source.number | PIDother
                              "/>
      </skos:Concept>
      <xsl:apply-templates select="." mode="metadata_identifier_links">
        <xsl:with-param name="database" select="$database"/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:apply-templates>
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template match="term | term/value">
    <skos:prefLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:if test="not(@lang!='')"><xsl:attribute name="xml:lang" select="'nl'"/></xsl:if>
      <xsl:value-of select="."/>    
    </skos:prefLabel>
  </xsl:template>
  
  <xsl:template match="equivalent_term | equivalent_term/value">
    <skos:altLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:if test="not(@lang!='')"><xsl:attribute name="xml:lang" select="'nl'"/></xsl:if>
      <xsl:value-of select="."/>    
    </skos:altLabel>
  </xsl:template>
  
  <xsl:template match="used_for | used_for/value">
    <skos:hiddenLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:if test="not(@lang!='')"><xsl:attribute name="xml:lang" select="'nl'"/></xsl:if>
      <xsl:value-of select="."/>    
    </skos:hiddenLabel>
  </xsl:template>
  
  <xsl:template match="scope_note | scope_note/value">
    <skos:scopeNote>
      <xsl:apply-templates select="@lang"/>
      <xsl:if test="not(@lang!='')"><xsl:attribute name="xml:lang" select="'nl'"/></xsl:if>
      <xsl:value-of select="."/>    
    </skos:scopeNote>
  </xsl:template>
  
  <xsl:template name="skos_relations">
    <xsl:attribute name="rdf:resource">
      <xsl:value-of select="$baseUri"/>
      <xsl:if test="not(guid)">
        <xsl:value-of select="concat('/', $database)"/>
      </xsl:if>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="guid"/>
      <xsl:value-of select="priref[not(guid!='')]"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="narrower_term">
    <skos:narrower>
      <xsl:call-template name="skos_relations"></xsl:call-template>
    </skos:narrower>
  </xsl:template>
  <xsl:template match="broader_term">
    <skos:broader>
      <xsl:call-template name="skos_relations"></xsl:call-template>
    </skos:broader>
  </xsl:template>
  <xsl:template match="related_term">
    <skos:related>
      <xsl:call-template name="skos_relations"></xsl:call-template>
    </skos:related>
  </xsl:template>
  <xsl:template match="equivalent_term">
    <skos:exactMatch>
      <xsl:call-template name="skos_relations"></xsl:call-template>
    </skos:exactMatch>
  </xsl:template>
  
  
  <xsl:template match="record/term.type">
    <skos:inScheme rdf:resource="{$baseUri}/{$database}/{value[@lang='neutral']/text()}"/>
  </xsl:template>
  
  <xsl:template match="record/term.type" mode="ConceptSchema">
    <skos:ConceptSchema rdf:about="{$baseUri}/{$database}/{value[@lang='neutral']/text()}">
      <xsl:apply-templates select="./value"/>
    </skos:ConceptSchema>
  </xsl:template>
  
  <xsl:template match="Source/source.number">
    <skos:exactMatch  rdf:resource="{.}"/>
  </xsl:template>
  
  <xsl:template match="PIDother">
    <xsl:if test="normalize-space(./PID_other.URI) != ''">
      <skos:exactMatch rdf:resource="{./PID_other.URI}" />
    </xsl:if>
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
