<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sdo="https://schema.org/"
>

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="Production_date">
    <xsl:choose>
      <xsl:when test="production.date.end/text()!='' and production.date.start/text()!='' and production.date.start/text()=production.date.end/text()">
        <sdo:dateCreated>
          <xsl:call-template name="xsdDateParser">
            <xsl:with-param name="value" select="production.date.start/text()"/>
          </xsl:call-template>
        </sdo:dateCreated>
      </xsl:when>
      <xsl:when test="production.date.end/text()!='' and production.date.start/text()!=''">
        <sdo:dateCreated>
          <xsl:value-of select="concat(production.date.start/text(), '/', production.date.end/text())"/>
        </sdo:dateCreated>
      </xsl:when>
      <xsl:when test="production.date.end/text()!='' and production.date.start/text()=''">
        <sdo:dateCreated>
          <xsl:value-of select="concat('-/', production.date.end/text())"/>
        </sdo:dateCreated>
      </xsl:when>
      <xsl:when test="production.date.end/text()='' and production.date.start/text()!=''">
        <sdo:dateCreated>
          <xsl:call-template name="xsdDateParser">
            <xsl:with-param name="value" select="production.date.start/text()"/>
          </xsl:call-template>
        </sdo:dateCreated>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
