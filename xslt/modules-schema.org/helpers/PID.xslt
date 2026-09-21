<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:sdo="https://schema.org/">

  <xsl:template match="PIDwork/PID_work_URI">
    <xsl:param name="id" />
    <sdo:identifier>
      <sdo:PropertyValue rdf:about="{$baseUri}/{translate(ancestor::record[1]/guid, '-', '')}#identifier-pid-work-{count(preceding-sibling::PID_work_URI) + 1}">
        <sdo:propertyID rdf:resource="https://www.wikidata.org/wiki/Q420330" />
        <sdo:value rdf:datatype="http://www.w3.org/2001/XMLSchema#anyURI">
          <xsl:value-of select="normalize-space(.)" />
        </sdo:value>
      </sdo:PropertyValue>
    </sdo:identifier>
  </xsl:template>

</xsl:stylesheet>
