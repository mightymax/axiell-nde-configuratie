<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:sdo="https://schema.org/">
  
  <!-- set customer URL for generic.xslt, cannot be a filename -->
  <xsl:import href="https://nde-apw.adlibhosting.com/Q666/xslt/schema.org/generic.xslt"/>
  <!-- set geothesau name: is thesau in 4x applications; geothesaurus in 5x -->
  <xsl:param name="geothesau">geothesaurus</xsl:param>
  
  <xsl:param name="database">persons-and-organisations</xsl:param>
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
      <xsl:choose>
        <xsl:when test="./name.type/value[@lang='neutral']='PERSON'">
          <xsl:apply-templates select="." mode="persons"/>
        </xsl:when>
        <xsl:when test="./name.type/value[@lang='neutral']='INST'">
          <xsl:apply-templates select="." mode="institutions"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- This is to be discussed: how to see if this is a person or a institution? -->
          <xsl:apply-templates select="." mode="institutions">
            <xsl:with-param name="id" select="$id"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="." mode="metadata_identifier_links">
        <xsl:with-param name="database" select="$database"/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:apply-templates>
      <!-- SKOS concepts for name types: -->
      <xsl:apply-templates select="./name.type/value[@lang='neutral']"/>
      <!-- Enrich SKOS concepts for nationalities & occupations;: -->
      <xsl:apply-templates select="./nationality.lref | ./occupation.lref" mode="enrich_skos_nationality"/>
    </rdf:RDF>
  </xsl:template>
  
  
  <xsl:template match="record" mode="institutions">
    <xsl:param name="id"/>
    <sdo:Organization rdf:about="{$baseUri}/{$database}/{$id}">
      <xsl:apply-templates select="." mode="metadata">
        <xsl:with-param name="database" select="$database"/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="name | nationality.lref | occupation.lref"/>
      <xsl:apply-templates select="name.type/value[@lang='neutral'] | name.type/value[@lang='neutral'] " mode="link_to_skos_concept"/>
    </sdo:Organization>
  </xsl:template>
  
  <xsl:template match="record" mode="persons">
    <xsl:variable name="id">
      <xsl:value-of select="guid"/>
      <xsl:value-of select="priref[not(../guid!='')]"/>
    </xsl:variable>
    <sdo:Person rdf:about="{$baseUri}/{$database}/{$id}">
      <xsl:apply-templates select="." mode="metadata">
        <xsl:with-param name="database" select="$database"/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="name | surname | biography | 
        birth.place.lref | death.place.lref | birth.date.start | 
        death.date.start | guid | nationality | occupation"/>
      <xsl:apply-templates select="name.type/value[@lang='neutral'] | name.type/value[@lang='neutral'] " mode="link_to_skos_concept"/>
    </sdo:Person>
  </xsl:template>
  
  <xsl:template match="name">
    <sdo:name>
      <xsl:value-of select="."/>
    </sdo:name>
  </xsl:template>
  
  <xsl:template match="nationality.lref">
    <sdo:nationality>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:if test="not(../guid)">
          <xsl:text>/thesaurus</xsl:text>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="../guid"/>
        <xsl:value-of select=".[not(../guid!='')]"/>
      </xsl:attribute>
    </sdo:nationality>
  </xsl:template>
  <xsl:template match="occupation.lref">
    <sdo:hasOccupation>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:if test="not(../guid)">
          <xsl:text>/thesaurus</xsl:text>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="../guid"/>
        <xsl:value-of select=".[not(../guid!='')]"/>
      </xsl:attribute>
    </sdo:hasOccupation>
  </xsl:template>
  <xsl:template match="nationality.lref" mode="enrich_skos_nationality">
    <sdo:Country>
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="$baseUri"/>
        <xsl:text>/thesaurus</xsl:text>
        <xsl:value-of select="../guid"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select=".[not(../guid!='')]"/>
      </xsl:attribute>
      <sdo:name><xsl:value-of select="."/></sdo:name>
    </sdo:Country>
  </xsl:template>
  
  <xsl:template match="occupation.lref" mode="enrich_skos_nationality">
    <sdo:Occupation>
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="$baseUri"/>
        <xsl:text>/thesaurus</xsl:text>
        <xsl:value-of select="../guid"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select=".[not(../guid!='')]"/>
      </xsl:attribute>
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
    <sdo:birthPlace>
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="$baseUri"/>
        <xsl:text>/thesaurus</xsl:text>
        <xsl:value-of select="../guid"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select=".[not(../guid!='')]"/>
      </xsl:attribute>
    </sdo:birthPlace>
  </xsl:template>
  
  <xsl:template match="death.place.lref">
    <sdo:deathPlace>
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="$baseUri"/>
        <xsl:text>/thesaurus</xsl:text>
        <xsl:value-of select="../guid"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select=".[not(../guid!='')]"/>
      </xsl:attribute>
    </sdo:deathPlace>
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
