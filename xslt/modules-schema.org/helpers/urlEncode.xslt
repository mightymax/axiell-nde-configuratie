<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="url-encode">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="string-length($s) = 0"/>
      <xsl:otherwise>
        <xsl:variable name="c" select="substring($s,1,1)"/>
        <xsl:choose>
          <xsl:when test="$c=' '">%20</xsl:when>
          <xsl:when test="$c=','">%2C</xsl:when>
          <xsl:when test="$c='/'">%2F</xsl:when>
          <xsl:when test="$c='&#92;'">%5C</xsl:when>
          <xsl:when test="$c='('">%28</xsl:when>
          <xsl:when test="$c=')'">%29</xsl:when>
          <xsl:when test="$c='['">%5B</xsl:when>
          <xsl:when test="$c=']'">%5D</xsl:when>
          <xsl:when test="$c='&quot;'">%22</xsl:when>
          <xsl:when test="$c=&quot;'&quot;">%27</xsl:when>
          <xsl:when test="$c='!'">%21</xsl:when>
          <xsl:when test="$c='%'">%25</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$c"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="url-encode">
          <xsl:with-param name="s" select="substring($s,2)"/>
        </xsl:call-template>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
