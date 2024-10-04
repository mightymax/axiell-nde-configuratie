<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"  
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/elements/1.1/"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="adlibXML">
    <xsl:apply-templates select="recordList"/>
  </xsl:template>

  <xsl:template match="recordList">
    <xsl:element name="recordList">
      <xsl:apply-templates select="record"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="record">
    <xsl:element name="oai_dc:dc">
      <xsl:apply-templates select="Title"/>
      <xsl:apply-templates select="Production"/>
      <xsl:apply-templates select="Content_person"/>
      <xsl:apply-templates select="Content_subject"/>
      <xsl:apply-templates select="institution.name" mode="dc.publisher"/>
      <xsl:apply-templates select="Associated_subject"/>
      <xsl:apply-templates select="Associated_person"/>
      <xsl:apply-templates select="Description"/>
      <xsl:apply-templates select="Production_date"/>
      <xsl:apply-templates select="Dating"/>
      <xsl:apply-templates select="Object_name"/>
      <xsl:apply-templates select="Dimension"/>
      <xsl:apply-templates select="object_number"/>
      <xsl:apply-templates select="institution.name"/>
      <xsl:call-template name="language"/>
      <xsl:apply-templates select="Related_object"/>
      <xsl:apply-templates select="credit_line"/>
      <xsl:apply-templates select="current_owner"/>
    </xsl:element>
  </xsl:template>

  <!-- Group matches -->
  <xsl:template match="Title">
    <xsl:apply-templates select="title"/>
  </xsl:template>

  <xsl:template match="Production">
    <xsl:apply-templates select="creator"/>
  </xsl:template>

  <xsl:template match="Content_person">
    <xsl:apply-templates select="content.person.name"/>
  </xsl:template>

  <xsl:template match="Content_subject">
    <xsl:apply-templates select="content.subject"/>
  </xsl:template>

  <xsl:template match="Associated_subject">
    <xsl:apply-templates select="association.subject"/>
  </xsl:template>

  <xsl:template match="Associated_person">
    <xsl:apply-templates select="association.person"/>
  </xsl:template>

  <xsl:template match="Description">
    <xsl:apply-templates select="description"/>
  </xsl:template>

  <xsl:template match="Production_date">
    <xsl:element name="dc:date">
      <xsl:apply-templates select="production.date.start[.!='']"/>
      <xsl:apply-templates select="production.date.end[.!='']"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Dating">
    <xsl:element name="dc:date">
      <xsl:apply-templates select="dating.date.start[.!='']"/>
      <xsl:apply-templates select="dating.date.end[.!='']"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Object_name">
    <xsl:apply-templates select="object_name"/>
  </xsl:template>

  <xsl:template match="Dimension">
    <xsl:element name="dc:format">
      <xsl:apply-templates select="dimension.part"/>
      <xsl:apply-templates select="dimension.type"/>
      <xsl:apply-templates select="dimension.value"/>
      <xsl:apply-templates select="dimension.unit"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Related_object">
    <xsl:apply-templates select="related_object.reference"/>
  </xsl:template>
  
  <!-- Field matches-->
  <xsl:template match="title">
    <xsl:element name="dc:title">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="creator">
    <xsl:element name="dc:creator">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="content.person.name | association.person">
    <xsl:element name="dc:subject">
      <xsl:value-of select="name"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="content.subject | association.subject">
    <xsl:element name="dc:subject">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="description">
    <xsl:element name="dc:description">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="production.date.start">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="production.date.end">
    <xsl:text> / </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="object_name">
    <xsl:element name="dc:type">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dimension.part">
    <xsl:value-of select="."/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="dimension.type">
    <xsl:value-of select="."/>
    <xsl:text>: </xsl:text>
  </xsl:template>

  <xsl:template match="dimension.value">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="dimension.unit">
    <xsl:text> </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="object_number">
    <xsl:element name="dc:identifier">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="institution.name">
    <xsl:element name="dc:source">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="institution.name" mode="dc.publisher">
    <xsl:element name="dc:publisher">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="language">
    <xsl:element name="dc:language">
      <xsl:text>Nederlands</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="related_object.reference">
    <xsl:element name="dc:relation">
      <xsl:value-of select="object_number"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="title"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="credit_line">
    <xsl:element name="dc:rights">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="current_owner">
    <xsl:element name="dcterms:provenance">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
