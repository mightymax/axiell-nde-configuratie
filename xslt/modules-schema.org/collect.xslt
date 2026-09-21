<?xml version="1.0" encoding="UTF-8"?>

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

  <xsl:import href="./generic.xslt" />
  <xsl:import href="./components.xslt" />
  <xsl:import href="./helpers.xslt" />

  <xsl:output method="xml" indent="yes" encoding="utf-8" />

  <!-- xsltproc \-\-stringparam customer Q123 \-\-ark_naan 1234 transform.xsl data.xml -->
  <xsl:param name="customer" />
  <xsl:param name="ark_naan" />
  <xsl:param name="imageUri">IMAGEURL</xsl:param>
  
  <xsl:param name="baseIdentifier">
    <xsl:value-of select="concat('ark:/', $ark_naan, '/')"/>
  </xsl:param>
  <xsl:param name="baseUri">
    <xsl:value-of select="concat('https://n2t.net/ark:/', $ark_naan)"/>
  </xsl:param>
  

  <xsl:template match="/adlibXML">
    <xsl:apply-templates select="recordList" />
  </xsl:template>

  <xsl:template match="recordList">
    <rdf:RDF>
      <xsl:apply-templates select="record" />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="record[guid!='']">
    <xsl:variable name="id">
      <xsl:value-of select="translate(guid, '-', '')" />
    </xsl:variable>
    <!-- <rdf:RDF> -->
    <sdo:CreativeWork rdf:about="{$baseUri}/{$id}">
      <!-- Object_name is the Axiell object classification. When it is present,
           expose the more specific Schema.org type while retaining CreativeWork
           as the RDF/XML container type. -->
      <xsl:if test="Object_name/object_name/term[normalize-space(.) != '']">
        <rdf:type rdf:resource="https://schema.org/VisualArtwork" />
      </xsl:if>
      <xsl:apply-templates select="." mode="metadata">
        <xsl:with-param name="id" select="$id" />
      </xsl:apply-templates>


      <!-- <xsl:apply-templates select="*|*/*|*/*/*|@*"/> -->
      <!-- Even tijdelijk om specifieke zaken te testen: -->
      <xsl:apply-templates select="@priref" />
      <xsl:apply-templates select="PIDwork/PID_work_URI" />

      <!-- Components: -->
      <xsl:apply-templates select="
        Production | 
        Associated_person | 
        Content_person | 
        Collection | Dimension | 
        Dimension | 
        Description |
        Media | 
        Reproduction |
        Related_object | 
        Rights | 
        Dating | 
        Production_date |
        Material | 
        Object_name | 
        Associated_subject | 
        Content_subject
        " 
      />
      <!-- Misc components -->
      <xsl:apply-templates select="Title | current_location.name | object_number | related_material.free_text" />

    </sdo:CreativeWork>


    <!-- Losse elementen, buiten het ArchiveComponent: -->
    <xsl:apply-templates select="
      Associated_subject | 
      Content_subject |
      Collection | 
      Production | 
      Material | 
      Associated_person | 
      Related_object | 
      Content_person |
      Object_name |
      Media |
      Reproduction
    " mode="StandAlone" />

  </xsl:template>

</xsl:stylesheet>
