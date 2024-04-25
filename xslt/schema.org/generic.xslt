<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:adlib="https://data.axiell.com/Axiell/vocabulary/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:sdo="https://schema.org/"
    >

  <!-- Change these per client: -->
  <!-- Name of client, this must be a simplified version using only letters, numbers and '-' -->
  <xsl:param name="customer">Q623558</xsl:param>
  <!-- Name of dataset, this must contain only letters, numbers and '-', leafe to 'dataset' if customeronly has 1 dataset/collection -->
  <xsl:param name="dataset">dataset</xsl:param>


  <xsl:param name="baseUri"><xsl:value-of select="concat('https://data.axiell.com/', $customer, '/', $dataset)"/></xsl:param>
  <!-- == Output =============================================== -->
  <xsl:output encoding="UTF-8" indent="yes" method="xml" media-type="application/xml" standalone="no" omit-xml-declaration="no"/>

  <xsl:template match="record" mode="metadata">
    <xsl:param name="database"/>
    <adlib:Record rdf:about="{$baseUri}/{$database}/{@priref}/metadata">
      <dct:created rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime"><xsl:value-of select="@created"/></dct:created>
      <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime"><xsl:value-of select="@created"/></dct:modified>
      <adlib:priref rdf:datatype="http://www.w3.org/2001/XMLSchema#int"><xsl:value-of select="@priref"/></adlib:priref>
      <xsl:if test="@selected='true'">
        <adlib:selected rdf:datatype="http://www.w3.org/2001/XMLSchema#boolean"><xsl:value-of select="@selected"/></adlib:selected>
      </xsl:if>
      <xsl:if test="@deleted='true'">
        <adlib:deleted rdf:datatype="http://www.w3.org/2001/XMLSchema#boolean"><xsl:value-of select="@selected"/></adlib:deleted>
      </xsl:if>
    </adlib:Record>
  </xsl:template>

  <!-- does not exist in 4.5 -->
  <xsl:template match="guid">
    <sdo:identifier><xsl:value-of select="."/></sdo:identifier>
  </xsl:template>

  <xsl:template name="xsdDateParser">
    <xsl:param name="value"/>
      <xsl:choose>
        <xsl:when test="translate($value, '0123456789', '##########') = '####-##-##'">
          <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#date</xsl:attribute>
        </xsl:when>
        <xsl:when test="translate($value, '0123456789', '##########') = '####'">
          <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#gYear</xsl:attribute>
        </xsl:when>
        <xsl:when test="translate($value, '0123456789', '##########') = '####-##'">
          <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#gYearMonth</xsl:attribute>
        </xsl:when>
        <xsl:when test="string-length(.)=5 and starts-with(.,'-')">
          <xsl:text>gYear</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="$value"/>
  </xsl:template>

  <xsl:template name="dateCreated">
    <xsl:param name="value"/>
    <sdo:dateCreated>
      <xsl:call-template name="xsdDateParser">
        <xsl:with-param name="value" select="$value"/> 
      </xsl:call-template>
    </sdo:dateCreated>
  </xsl:template>


  <xsl:template match="Title/title | record/title">
    <sdo:name>
      <xsl:value-of select="."/>
    </sdo:name>
  </xsl:template>

  <xsl:template match="Description/description | record/description">
    <sdo:description><xsl:value-of select="."/></sdo:description>
  </xsl:template>

  <!-- do not map diagnostics -->
  <xsl:template match="diagnostic"/>
  <!-- do not map edit_history -->
  <xsl:template match="record/edit_history"/>

  <xsl:template match="@lang">
    <xsl:attribute name="xml:lang">
      <xsl:choose>
        <xsl:when test=". = 0">en</xsl:when>
        <xsl:when test=". = 1">nl</xsl:when>
        <xsl:when test=". = 1">nl</xsl:when>
        <xsl:when test=". = 2">fr</xsl:when>
        <xsl:when test=". = 3">de</xsl:when>
        <xsl:when test=". = 4">ar</xsl:when>
        <xsl:when test=". = 5">it</xsl:when>
        <xsl:when test=". = 6">el</xsl:when>
        <xsl:when test=". = 9">sv</xsl:when>
        <xsl:when test=". = 10">he</xsl:when>
        <xsl:when test=". = 11">da</xsl:when>
        <xsl:when test=". = 14">zh</xsl:when>
        <xsl:otherwise>neutral</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="*|@*" />
</xsl:stylesheet>