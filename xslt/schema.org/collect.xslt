<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns="http://www.openarchives.org/OAI/2.0/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
                xmlns:sdo="https://schema.org/">
  
  <xsl:import href="https://nde-apw.adlibhosting.com/Q666/xslt/schema.org/generic.xslt"/>
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
    <xsl:variable name="id">
      <xsl:value-of select="guid"/>
      <xsl:value-of select="priref[not(../guid!='')]"/>
    </xsl:variable>
    <rdf:RDF>
      <sdo:ArchiveComponent rdf:about="{$baseUri}/{$id}">
        <xsl:apply-templates select="." mode="metadata">
          <xsl:with-param name="id" select="$id"/>
          <xsl:with-param name="database" select="$database"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*|*/*|*/*/*|@*"/>
      </sdo:ArchiveComponent>
      <xsl:apply-templates select="." mode="metadata_identifier_links">
        <xsl:with-param name="id" select="$id"/>
        <xsl:with-param name="database" select="$database"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="PIDwork/PID_work_URI" mode="PID">
        <xsl:with-param name="id" select="$id"/>
      </xsl:apply-templates>
      
      <xsl:apply-templates select="./Dimension" mode="QuantitativeValue">
        <xsl:with-param name="id" select="$id"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./Production/creator.role.lref" mode="Role">
        <xsl:with-param name="id" select="$id"/>
      </xsl:apply-templates>
    </rdf:RDF>
  </xsl:template>
  <xsl:template match="collection.name.lref[not(../collection.name/guid!='')]">
    <sdo:isPartOf rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="Collection/collection.name/guid">
    <sdo:isPartOf rdf:resource="{$baseUri}/{.}"/>
  </xsl:template>
  <!-- Location is linked to location database which is not harvested!! needs to be discussed -->
  <!--   <xsl:template match="current_location.lref[not(../current_location.name/guid!='')]"> -->
  <!-- <xsl:template match="current_location.lref">
       <sdo:itemLocation rdf:resource="{$baseUri}/thesaurus/{.}"/>
       </xsl:template> -->
  <!--   <xsl:template match="current_location.name/guid">
       <sdo:itemLocation rdf:resource="{$baseUri}/{.}"/>
       </xsl:template> -->
  <xsl:template match="institution.name/guid">
    <sdo:holdingArchive rdf:resource="{$baseUri}/{.}"/>
  </xsl:template>
  <xsl:template match="institution.name.lref[not(../institution.name/guid!='')]">
    <sdo:holdingArchive rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  
  <xsl:template match="Object_name/object_name.lref[not(../object_name/guid!='')]">
    <sdo:additionalType rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="Object_name/object_name/guid">
    <sdo:additionalType rdf:resource="{$baseUri}/{.}"/>
  </xsl:template>
  
  <xsl:template match="Material[not(material/guid!='')]/material.lref">
    <sdo:material rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>
  <xsl:template match="Material/material/guid">
    <sdo:material rdf:resource="{$baseUri}/{.}"/>
  </xsl:template>
  
  <xsl:template match="Related_object[not(related_object.reference/guid!='')]/related_object.reference.lref">
    <rdfs:seeAlso rdf:resource="{$baseUri}/{$database}/{.}"/>
  </xsl:template>
  <xsl:template match="Related_object/related_object.reference/guid">
    <rdfs:seeAlso rdf:resource="{$baseUri}/{.}"/>
  </xsl:template>
  
  <xsl:template match="dimension.precision/value">    <!-- ?? -->
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
  <xsl:template match="Media[not(media.reference/guid!='')]/media.reference.lref">
    <sdo:associatedMedia rdf:resource="{$baseUri}/media/{.}" />
  </xsl:template>
  <xsl:template match="Media/media.reference/guid">
    <sdo:associatedMedia rdf:resource="{$baseUri}/{.}" />
  </xsl:template>
  <!-- 4.x -->
  <xsl:template match="Production/production.place.lref[not(../production.place/guid!='')]">
    <sdo:locationCreated rdf:resource="{$baseUri}/thesaurus/{.}" />
  </xsl:template>
  <xsl:template match="Production/production.place/guid">
    <sdo:locationCreated rdf:resource="{$baseUri}/{.}" />
  </xsl:template>
  <xsl:template match="creator.lref[not(../creator/guid!='')]">
    <sdo:creator rdf:resource="{$baseUri}/persons-and-organisations/{.}" />
  </xsl:template>
  <xsl:template match="Production/creator/guid">
    <sdo:creator rdf:resource="{$baseUri}/{.}" />
  </xsl:template>
  <xsl:template match="Dimension" mode="QuantitativeValue">
    <xsl:param name="id"/>
    <rdf:Description rdf:about="{$baseUri}/{$id}">
      <sdo:size rdf:resource="{$baseUri}/{$id}#dimension-{position()}" />
    </rdf:Description>
    <sdo:QuantitativeValue rdf:about="{$baseUri}/{$id}#dimension-{position()}">
      <sdo:additionalType>
        <xsl:attribute name="rdf:resource">
          <xsl:value-of select="$baseUri"/>
          <xsl:if test="not(dimension.type/guid)">
            <xsl:text>/thesaurus</xsl:text>
          </xsl:if>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="dimension.type/guid"/>
          <xsl:value-of select="dimension.type.lref[not(../dimension.type/guid!='')]"/>
        </xsl:attribute>
      </sdo:additionalType>
      
      <xsl:if test="dimension.type/term/text()!=''">
        <sdo:name>
          <xsl:value-of select="dimension.type/term"/>
        </sdo:name>
      </xsl:if>
      <xsl:if test="dimension.unit/term/text()!=''">
        <sdo:unitText>
          <xsl:value-of select="dimension.unit/term"/>
        </sdo:unitText>
      </xsl:if>
      <sdo:unitCode>
        <xsl:attribute name="rdf:resource">
          <xsl:value-of select="$baseUri"/>
          <xsl:if test="not(dimension.unit/guid)">
            <xsl:text>/thesaurus</xsl:text>
          </xsl:if>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="dimension.unit/guid"/>
          <xsl:value-of select="dimension.unit.lref[not(../dimension.unit/guid!='')]"/>
        </xsl:attribute>
      </sdo:unitCode>
      <xsl:if test="dimension.value!=''">
        <sdo:value rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
          <xsl:value-of select="dimension.value"/>
        </sdo:value>
      </xsl:if>
      <xsl:if test="dimension.part">
        <sdo:description>
          <xsl:value-of select="dimension.part"/>
        </sdo:description>
      </xsl:if>
      <xsl:apply-templates select="dimension.precision/value[@lang!='neutral']"/>
    </sdo:QuantitativeValue>
  </xsl:template>
  
  <xsl:template match="current_location.name/guid|dimension.type/guid|dimension.unit/guid|creator.role/guid"/>
  
  <xsl:template match="Associated_period/association.period/guid">
    <sdo:temporalCoverage rdf:resource="{$baseUri}/{.}" />
  </xsl:template>
  
  <xsl:template match="Associated_period/association.period.date.start">
    <sdo:temporalCoverage>
      <xsl:value-of select="."/>
      <xsl:if test="../association.period.date.end/text() and ./text() != ../association.period.date.end/text()">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="../association.period.date.end"/>
      </xsl:if>
    </sdo:temporalCoverage>
  </xsl:template>
  
  <xsl:template match="Production/creator.role.lref[.!='']" mode="Role">
    <xsl:param name="id"/>
    <rdf:Description rdf:about="{$baseUri}/{$id}">
      <sdo:role rdf:resource="{$baseUri}/{$id}#role-{position()}" />
    </rdf:Description>
    <sdo:Role rdf:about="{$baseUri}/{$id}#role-{position()}">
      <sdo:roleName>
        <xsl:value-of select="../creator.role/term"/>
      </sdo:roleName>
      <sdo:additionalType>
        <xsl:attribute name="rdf:resource">
          <xsl:value-of select="$baseUri"/>
          <xsl:if test="not(../creator.role/guid)">
            <xsl:text>/thesaurus</xsl:text>
          </xsl:if>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="../creator.role/guid"/>
          <xsl:value-of select="../creator.role.lref[not(../creator.role/guid!='')]"/>
        </xsl:attribute>
      </sdo:additionalType>
      <sdo:subject>
        <xsl:attribute name="rdf:resource">
          <xsl:value-of select="$baseUri"/>
          <xsl:if test="not(../creator/guid)">
            <xsl:text>/thesaurus</xsl:text>
          </xsl:if>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="../creator/guid"/>
          <xsl:value-of select="../creator.lref[not(../creator/guid!='')]"/>
        </xsl:attribute>
      </sdo:subject>
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
    <sdo:copyrightNotice>
      <xsl:value-of select="."/>
    </sdo:copyrightNotice>
  </xsl:template>
  
  <xsl:template match="PIDwork/PID_work_URI" mode="PID">
    <xsl:param name="id"/>
    <sdo:PropertyValue rdf:about="{$baseUri}/{$id}#PID-{position()}">
      <sdo:additionalType rdf:resource="https://www.wikidata.org/wiki/Q420330"/>
      <sdo:value rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
        <xsl:value-of select="."/>
      </sdo:value>
      <sdo:about rdf:resource="{$baseUri}/{$id}"/>
    </sdo:PropertyValue>
  </xsl:template>
  
  <xsl:template match="Rights/rights.holder.lref">
    <sdo:copyrightHolder rdf:resource="{$baseUri}/persons-and-organisations/{.}"/>
  </xsl:template>
  <xsl:template match="Rights/association.geographical_keyword/guid">
    <sdo:copyrightHolder rdf:resource="{$baseUri}/{.}"/>
  </xsl:template>
  
  <xsl:template match="
    Associated_person/association.person/guid
    | Associated_subject/association.subject/guid
    | Content_subject/content.subject/guid
    | Content_person/content.person.name/guid
                  ">
    <sdo:keywords>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:value-of select="."/>
      </xsl:attribute>
    </sdo:keywords>
  </xsl:template>
  
</xsl:stylesheet>
