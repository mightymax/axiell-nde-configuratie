<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:adlib="https://data.axiell.com/Axiell/vocabulary#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:sdo="https://schema.org/"
  >
  
  <xsl:param name="customer" />
  <xsl:param name="ark_naan" />
  
  <xsl:param name="baseIdentifier">
    <xsl:value-of select="concat('ark:/', $ark_naan, '/')"/>
  </xsl:param>
  <xsl:param name="baseUri">
    <xsl:value-of select="concat('https://n2t.net/ark:/', $ark_naan)"/>
  </xsl:param>
  <!-- == Output =============================================== -->
  <xsl:output encoding="UTF-8" indent="yes" method="xml" media-type="application/xml" standalone="no" omit-xml-declaration="no"/>
  
  <xsl:template match="record" mode="metadata">
    <xsl:param name="id" />
    <xsl:param name="database" />
    <dct:created rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime"><xsl:value-of select="@created"/></dct:created>
    <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime"><xsl:value-of select="@modification"/></dct:modified>
    <xsl:if test="@selected='true'">
      <adlib:selected rdf:datatype="http://www.w3.org/2001/XMLSchema#boolean"><xsl:value-of select="@selected"/></adlib:selected>
    </xsl:if>
    <xsl:if test="@deleted='true'">
      <adlib:deleted rdf:datatype="http://www.w3.org/2001/XMLSchema#boolean"><xsl:value-of select="@selected"/></adlib:deleted>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*|@*" />
</xsl:stylesheet>
