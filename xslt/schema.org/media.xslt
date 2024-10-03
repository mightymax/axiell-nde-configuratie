<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:iiif="http://iiif.io/api/presentation/3#"
    xmlns:adlib="https://data.axiell.com/Axiell/vocabulary/"
    xmlns:sdo="https://schema.org/"  >

  <xsl:import href="https://nde-apw.adlibhosting.com/Q666/xslt/schema.org/generic.xslt"/>
  <xsl:param name="database">media</xsl:param>
  <xsl:param name="imageUri">IMAGEURL</xsl:param>
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
      <xsl:variable name="MediaType">
      <xsl:choose>
        <xsl:when test="./media_type = 'digital image'">
          <xsl:value-of select="'sdo:ImageObject'" />
        </xsl:when>
        <xsl:when test="./media_type = 'digital audio'">
          <xsl:value-of select="'sdo:AudioObject'" />
        </xsl:when>
        <xsl:when test="./media_type = 'digital video'">
          <xsl:value-of select="'sdo:VideoObject'" />
        </xsl:when>
        <xsl:when test="./reproduction_type = 'digital image'">
          <xsl:value-of select="'sdo:ImageObject'" />
        </xsl:when>
        <xsl:when test="./reproduction_type = 'digital audio'">
          <xsl:value-of select="'sdo:AudioObject'" />
        </xsl:when>
        <xsl:when test="./reproduction_type = 'digital video'">
          <xsl:value-of select="'sdo:VideoObject'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'sdo:MediaObject'" />
        </xsl:otherwise>
      </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$MediaType}">
        <xsl:attribute name="rdf:about"><xsl:value-of select="concat($baseUri, '/', $database, '/', @priref)" /></xsl:attribute>
        <xsl:apply-templates select="*|@*"/>
        <!-- 
        <iiif:manifest>https://api.triplydb.com/queries/Axiell/IIIF-Manifest/run?identifier=1</iiif:manifest> 
        -->
        <xsl:call-template name="dateCreated">
          <xsl:with-param name="value" select="production_date[text() != '']"/>
        </xsl:call-template>
      </xsl:element>
    </rdf:RDF>
  </xsl:template>

  <!-- ============= TEMPLATES ============= -->

  <xsl:template match="media_type.lref | reproduction_type.lref" >
    <sdo:additionalType rdf:resource="{$baseUri}/thesaurus/{.}"/>
  </xsl:template>

  <xsl:template match="format" >
    <sdo:encodingFormat><xsl:value-of select="."/></sdo:encodingFormat>
  </xsl:template>

  <xsl:template match="title | reference_number">
    <sdo:name>
      <xsl:value-of select="."/>
    </sdo:name>
  </xsl:template>

  <xsl:template match="reference_number">
    <sdo:name><xsl:value-of select="."/></sdo:name>
    <sdo:thumbnailURL rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
      <xsl:value-of select="concat($imageUri, normalize-space(.), '&amp;width=250&amp;height=250')"/>
    </sdo:thumbnailURL>
    <sdo:contentUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
      <xsl:value-of select="concat($imageUri, normalize-space(.))"/>
    </sdo:contentUrl>
  </xsl:template>

</xsl:stylesheet>
