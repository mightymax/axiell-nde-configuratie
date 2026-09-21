<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdo="https://schema.org/"
>

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="Dating">
    <!-- eignelijk zou hier nog datatype aan toe moeten worden gevoegd, maar dat vergt een aanpassing aan Axiell -->
    <xsl:choose>
      <xsl:when test="dating.date.end/text()!='' and dating.date.start/text()!='' and dating.date.start/text()=dating.date.end/text()">
        <sdo:dateCreated>
          <xsl:call-template name="xsdDateParser">
            <xsl:with-param name="value" select="dating.date.start/text()"/> 
          </xsl:call-template>
        </sdo:dateCreated>
      </xsl:when>
      <xsl:when test="dating.date.end/text()!='' and dating.date.start/text()!=''">
        <sdo:dateCreated>
          <xsl:value-of select="concat(dating.date.start/text(), '/', dating.date.end/text())"/>
        </sdo:dateCreated>
      </xsl:when>
      <xsl:when test="dating.date.end/text()!='' and dating.date.start/text()=''">
        <sdo:dateCreated>
          <xsl:value-of select="concat('-', '/', dating.date.end/text())"/>
        </sdo:dateCreated>
      </xsl:when>
      <xsl:when test="dating.date.end/text()='' and dating.date.start/text()!=''">
        <sdo:dateCreated>
          <xsl:call-template name="xsdDateParser">
            <xsl:with-param name="value" select="dating.date.start/text()"/> 
          </xsl:call-template>
        </sdo:dateCreated>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="dateCreated">
    <xsl:param name="value"/>
    <xsl:if test="$value!=''">
      <sdo:dateCreated>
        <xsl:call-template name="xsdDateParser">
          <xsl:with-param name="value" select="$value"/> 
        </xsl:call-template>
      </sdo:dateCreated>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>