<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:adlib="https://data.axiell.com/Axiell/vocabulary/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:sdo="https://schema.org/">

  <!-- set customer URL for generic.xslt, cannot be a filename -->
  <xsl:import href="https://nde-apw.adlibhosting.com/Q666/xslt/schema.org/generic.xslt"/>
  <!-- set geothesau name: is thesau in 4x applications; geothesaurus in 5x -->
  <xsl:param name="geothesau">geothesaurus</xsl:param>
  
  <xsl:param name="database">persons_and_organisations</xsl:param>
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
      <xsl:choose>
        <xsl:when test="./name.type/value[@lang='neutral']='PERSON'">
          <xsl:apply-templates select="." mode="persons"/>
        </xsl:when>
        <xsl:when test="./name.type/value[@lang='neutral']='INST'">
          <xsl:apply-templates select="." mode="institutions"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- This is to be discussed: how to see if this is a person or a institution? -->
          <xsl:apply-templates select="." mode="institutions"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- SKOS concepts for name types: -->
      <xsl:apply-templates select="./name.type/value[@lang='neutral']"/>
      <!-- Enrich SKOS concepts for nationalities & occupations;: -->
      <xsl:apply-templates select="./nationality.lref | ./occupation.lref" mode="enrich_skos_nationality"/>
      <xsl:call-template name="dereferencableUri">
        <xsl:with-param name="database" select="$database" />
        <xsl:with-param name="priref" select="@priref" />
      </xsl:call-template>
    </rdf:RDF>
  </xsl:template>

  
  <xsl:template match="record" mode="institutions">
    <sdo:Organization rdf:about="{$baseUri}/{$database}/{./@priref}">
      <xsl:apply-templates select="name | guid | nationality.lref | occupation.lref"/>
      <xsl:apply-templates select="name.type/value[@lang='neutral'] | name.type/value[@lang='neutral'] " mode="link_to_skos_concept"/>
    </sdo:Organization>
  </xsl:template>

  <xsl:template match="record" mode="persons">
    <sdo:Person rdf:about="{$baseUri}/{$database}/{./@priref}">
      <xsl:apply-templates select="name | surname | biography | 
        birth.place.lref | death.place.lref | birth.date.start | 
        death.date.start | guid | nationality.lref | occupation.lref"/>
      <xsl:apply-templates select="name.type/value[@lang='neutral'] | name.type/value[@lang='neutral'] " mode="link_to_skos_concept"/>
    </sdo:Person>
  </xsl:template>

  <xsl:template match="name">
    <sdo:name>
      <xsl:value-of select="."/>
    </sdo:name>
  </xsl:template>
  
  <xsl:template match="nationality.lref">
    <sdo:nationality rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="occupation.lref">
    <sdo:hasOccupation rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="nationality.lref" mode="enrich_skos_nationality">
    <sdo:Country rdf:about="{$baseUri}/thesaurus/{.}">
      <sdo:name><xsl:value-of select="../nationality"/></sdo:name>
    </sdo:Country>
  </xsl:template>
  <xsl:template match="occupation.lref" mode="enrich_skos_nationality">
    <sdo:Occupation rdf:about="{$baseUri}/thesaurus/{.}">
      <sdo:name><xsl:value-of select="../occupation"/></sdo:name>
    </sdo:Occupation>
  </xsl:template>

  <xsl:template match="name.type/value" mode="link_to_skos_concept">
    <xsl:if test=". != 'PERSON'">
      <sdo:additionalType rdf:resource="{$baseUri}/{$database}/types/{.}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="record/name.type/value[@lang='neutral']">
    <xsl:if test=". != 'PERSON' and . != 'INST'">
      <skos:Concept rdf:about="{$baseUri}/{$database}/types/{.}">
        <xsl:apply-templates select="../value[@lang!='neutral']"/>
      </skos:Concept>
    </xsl:if>
  </xsl:template>
  <xsl:template match="record/name.type/value[@lang!='neutral']">
    <skos:prefLabel>
      <xsl:apply-templates select="@lang"/>
      <xsl:value-of select="."/>
    </skos:prefLabel>
  </xsl:template>

  <xsl:template match="surname">
    <sdo:familyName>
      <xsl:value-of select="."/>
    </sdo:familyName>
  </xsl:template>
  
  <xsl:template match="biography">
    <sdo:description>
      <xsl:value-of select="."/>
    </sdo:description>
  </xsl:template>
  
  <xsl:template match="birth.place.lref">
    <sdo:birthPlace rdf:resource="{$baseUri}/{$geothesau}/{.}" />
  </xsl:template>
  
  <xsl:template match="death.place.lref">
    <sdo:deathPlace rdf:resource="{$baseUri}/{$geothesau}/{.}" />
  </xsl:template>
  
  <xsl:template match="birth.date.start">
    <sdo:birthDate>
      <xsl:call-template name="xsdDateParser">
        <xsl:with-param name="value" select="."/> 
      </xsl:call-template>
    </sdo:birthDate>
  </xsl:template>
  
  <xsl:template match="death.date.start">
    <sdo:deathDate>
      <xsl:call-template name="xsdDateParser">
        <xsl:with-param name="value" select="."/> 
      </xsl:call-template>
    </sdo:deathDate>
  </xsl:template>
  
</xsl:stylesheet>
