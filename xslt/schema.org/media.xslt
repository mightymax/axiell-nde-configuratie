<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:iiif="http://iiif.io/api/presentation/3#"
                xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
                xmlns:sdo="https://schema.org/"  >
  
  <xsl:import href="https://nde-apw.adlibhosting.com/Q666/xslt/schema.org/generic.xslt"/>
  <xsl:param name="database">media</xsl:param>
  <xsl:param name="imageUri">https://epg.adlibhosting.com/axiellimageapi/wwwopac.ashx?command=getcontent&amp;server=EPG-Zoutkamp&amp;value=</xsl:param>
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
        <xsl:attribute name="rdf:about"><xsl:value-of select="concat($baseUri, '/', $id)" /></xsl:attribute>
        <xsl:apply-templates select="." mode="metadata">
          <xsl:with-param name="id" select="$id"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*|@*"/>
        <xsl:call-template name="dateCreated">
          <xsl:with-param name="value" select="production_date[text() != '']"/>
        </xsl:call-template>
      </xsl:element>
      <xsl:apply-templates select="." mode="metadata_identifier_links">
        <xsl:with-param name="id" select="$id"/>
        <xsl:with-param name="database" select="$database"/>
      </xsl:apply-templates>
    </rdf:RDF>
  </xsl:template>
  
  <!-- ============= TEMPLATES ============= -->
  
  <xsl:template match="media_type | reproduction_type" >
    <sdo:additionalType>
      <xsl:attribute name="rdf:resource">
        <xsl:value-of select="$baseUri"/>
        <xsl:if test="not(guid)">
          <xsl:text>/thesaurus</xsl:text>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="guid"/>
        <xsl:value-of select="priref[not(../guid!='')]"/>
      </xsl:attribute>
    </sdo:additionalType>
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
    <xsl:variable name="formattedImageUri">
      <xsl:choose>
        <xsl:when test="contains($imageUri,'%data%')">
          <xsl:value-of select="replace($imageUri, '%data%', normalize-space(.))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($imageUri, normalize-space(.))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="formattedThumbUri">
      <xsl:choose>
        <xsl:when test="contains($imageUri,'wwwopac.ashx')">
          <xsl:value-of select="concat($formattedImageUri, '&amp;width=250&amp;height=250')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$formattedImageUri"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <sdo:thumbnailUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
      <xsl:value-of select="$formattedThumbUri"/>
    </sdo:thumbnailUrl>
    <sdo:contentUrl rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
      <xsl:value-of select="$formattedImageUri"/>
    </sdo:contentUrl>
  </xsl:template>
  
</xsl:stylesheet>
