<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns="http://www.openarchives.org/OAI/2.0/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:adlib="https://data.axiell.com/Axiell/vocabulary/"
    xmlns:sdo="https://schema.org/"  >

  <xsl:import href="https://nde-apw.adlibhosting.com/Q1820897/xslt/oai/schema.org/generic.xslt"/>
  <xsl:param name="database">collection</xsl:param>
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
      <sdo:ArchiveComponent rdf:about="{$baseUri}/{$database}/{@priref}">
        <xsl:apply-templates select="*|*/*|@*"/>
      </sdo:ArchiveComponent>
      <xsl:apply-templates select="./Dimension" mode="QuantitativeValue"/>
      <xsl:apply-templates select="./Production/creator.role.lref" mode="Role"/>
    </rdf:RDF>
  </xsl:template>
  <xsl:template match="collection.lref">
    <sdo:isPartOf rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="current_location.lref">
    <sdo:itemLocation rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="institution.name.lref">
    <sdo:holdingArchive rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="Object_name/object_name.lref">
    <sdo:additionalType rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="Material/material.lref">
    <sdo:material rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="Related_object/related_object.association.lref">
    <rdfs:seeAlso rdf:resource="{$baseUri}/{$database}/{.}"/>
  </xsl:template>

  <xsl:template match="dimension.precision/value"> <!-- ?? -->
    <sdo:marginOfError>
      <xsl:apply-templates select="@lang"/>
      <xsl:value-of select="."/>
    </sdo:marginOfError>
  </xsl:template>
  <!-- 4.x -->
  <xsl:template match="Reproduction/reproduction.reference.lref">
    <sdo:associatedMedia rdf:resource="{$baseUri}/media/{.}" />
  </xsl:template>
  <!-- 5.x -->
  <xsl:template match="Media/media.reference.lref">
    <sdo:associatedMedia rdf:resource="{$baseUri}/media/{.}" />
  </xsl:template>
  <!-- 4.x -->
  <xsl:template match="Production/production.place.lref">
    <sdo:locationCreated rdf:resource="{$baseUri}/thesaurus/{.}" />
  </xsl:template>
  <xsl:template match="creator.lref">
    <sdo:creator rdf:resource="{$baseUri}/persons-and-organisations/{.}" />
  </xsl:template>

  <xsl:template match="Dimension" mode="QuantitativeValue">
    <sdo:QuantitativeValue rdf:about="{$baseUri}/{$database}/{../@priref}/dimension/{position()}">
      <sdo:additionalType rdf:resource="{$baseUri}/thesaurus/{dimension.type.lref}" />
      <sdo:name><xsl:value-of select="dimension.type"/></sdo:name>
      <sdo:unitText><xsl:value-of select="dimension.unit"/></sdo:unitText>
      <sdo:unitCode rdf:resource="{$baseUri}/thesaurus/{dimension.unit.lref}" />
      <xsl:if test="dimension.value!=''">
        <sdo:value rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal"><xsl:value-of select="dimension.value"/></sdo:value>
      </xsl:if>
      <xsl:if test="dimension.part">
        <sdo:description><xsl:value-of select="dimension.part"/></sdo:description>
      </xsl:if>
      <xsl:apply-templates select="dimension.precision/value[@lang!='neutral']"/>
    </sdo:QuantitativeValue>
    <rdf:Description rdf:about="{$baseUri}/{$database}/{../@priref}">
      <sdo:size rdf:resource="{$baseUri}/{$database}/{../@priref}/dimension/{position()}" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="Production/creator.role.lref" mode="Role">
    <sdo:Role rdf:about="{$baseUri}/{$database}/{../../@priref}/role/{position()}">
      <sdo:roleName><xsl:value-of select="../creator.role"/></sdo:roleName>
      <sdo:additionalType rdf:resource="{$baseUri}/thesaurus/{.}" />
      <sdo:about rdf:resource="{$baseUri}/{$database}/{../../@priref}"/>
      <sdo:subject rdf:resource="{$baseUri}/persons-and-organisations/{../creator.lref}"/>
    </sdo:Role>
  </xsl:template>

  <!-- 4.x -->
  <xsl:template match="Production_date">
   <!-- What kind of data is this? A: ISO date -->
   <xsl:choose>
    <xsl:when test="production.date.end | production.date.start">
      <sdo:temporal>
        <xsl:call-template name="xsdDateParser">
          <xsl:with-param name="value" select="production.date.end"/> 
        </xsl:call-template>
      </sdo:temporal>      
    </xsl:when>
    <xsl:otherwise>
      <!-- This is semantically incorrect! -->
      <sdo:endDate>
        <xsl:call-template name="xsdDateParser">
          <xsl:with-param name="value" select="production.date.end"/> 
        </xsl:call-template>
      </sdo:endDate>      
      <sdo:startDate>
        <xsl:call-template name="xsdDateParser">
          <xsl:with-param name="value" select="production.date.start"/> 
        </xsl:call-template>
      </sdo:startDate>      
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>
  <!-- 5.x -->
  <xsl:template match="Dating">
   <!-- What kind of data is this? -->
   <xsl:choose>
    <xsl:when test="dating.date.end and dating.date.end = dating.date.start">
      <sdo:temporal>
        <xsl:call-template name="xsdDateParser">
          <xsl:with-param name="value" select="dating.date.end"/> 
        </xsl:call-template>
      </sdo:temporal>      
    </xsl:when>
    <xsl:otherwise>
      <!-- This is semantically incorrect! -->
      <sdo:endDate>
        <xsl:call-template name="xsdDateParser">
          <xsl:with-param name="value" select="dating.date.end"/> 
        </xsl:call-template>
      </sdo:endDate>      
      <sdo:startDate>
        <xsl:call-template name="xsdDateParser">
          <xsl:with-param name="value" select="dating.date.start"/> 
        </xsl:call-template>
      </sdo:startDate>      
    </xsl:otherwise>
   </xsl:choose>
  </xsl:template>

  <xsl:template match="production.period">
    <xsl:call-template name="dateCreated">
      <xsl:with-param name="value" select="."/> 
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="Rights/rights.type">
    <sdo:copyrightNotice><xsl:value-of select="."/></sdo:copyrightNotice>
  </xsl:template>

  <xsl:template match="Rights/rights.holder.lref">
    <sdo:copyrightHolder rdf:resource="{$baseUri}/persons-and-organisations/{.}"/>
  </xsl:template>

  <xsl:template match="
      Associated_person/association.person.lref 
    | Associated_subject/association.subject.lref
    | Content_subject/content.subject.lref
    | Content_person/content.person.name.lref
  ">
    <dc:subject rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  
</xsl:stylesheet>
