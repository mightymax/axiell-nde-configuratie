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

  <xsl:template match="Production">
    <xsl:variable name="productionPidUri"
      select=".//PIDother/PID_other.URI
      | .//PIDother/PID_other_URI
      | .//PIDdata/PID_data.URI
      | .//PIDdata/PID_data_URI
      | .//PID_other.URI
      | .//PID_other_URI
      | .//PID_data.URI
      | .//PID_data_URI" />
    <xsl:variable name="productionPlacePidUri"
      select="production.place/PIDother/PID_other.URI
      | production.place/PIDother/PID_other_URI
      | production.place/PIDdata/PID_data.URI
      | production.place/PIDdata/PID_data_URI
      | production.place/PID_other.URI
      | production.place/PID_other_URI
      | production.place/PID_data.URI
      | production.place/PID_data_URI" />
    <xsl:variable name="productionPidUriValue" select="normalize-space($productionPidUri)" />
    <xsl:variable name="productionPlacePidUriValue" select="normalize-space($productionPlacePidUri)" />
    <xsl:variable name="creatorRoleSourceUri" select="normalize-space(creator.role/Source/source.number)" />
    <xsl:variable name="creatorSourceUri" select="normalize-space(creator/Source/source.number)" />

    <xsl:choose>
      <xsl:when test="creator.role">
        <sdo:creator>
          <sdo:Role rdf:about="{$baseUri}/{translate(ancestor::record[1]/guid, '-', '')}#production-role-{count(preceding-sibling::Production) + 1}">
            <xsl:if test="$creatorRoleSourceUri != '' and (starts-with($creatorRoleSourceUri, 'http://') or starts-with($creatorRoleSourceUri, 'https://') or starts-with($creatorRoleSourceUri, 'urn:') or starts-with($creatorRoleSourceUri, 'ark:'))">
              <sdo:additionalType rdf:resource="{$creatorRoleSourceUri}" />
            </xsl:if>
            <sdo:name>
              <xsl:value-of select="creator.role/term" />
            </sdo:name>
            <xsl:if test="creator/guid">
              <sdo:creator rdf:resource="{$baseUri}/{translate(creator/guid, '-', '')}" />
            </xsl:if>
            <xsl:if test="$creatorRoleSourceUri != '' and (starts-with($creatorRoleSourceUri, 'http://') or starts-with($creatorRoleSourceUri, 'https://') or starts-with($creatorRoleSourceUri, 'urn:') or starts-with($creatorRoleSourceUri, 'ark:'))">
              <sdo:creator rdf:resource="{$creatorRoleSourceUri}" />
            </xsl:if>
          </sdo:Role>
        </sdo:creator>
      </xsl:when>
      <xsl:when test="$productionPidUriValue != '' and (starts-with($productionPidUriValue, 'http://') or starts-with($productionPidUriValue, 'https://') or starts-with($productionPidUriValue, 'urn:') or starts-with($productionPidUriValue, 'ark:'))">
        <sdo:contributor rdf:resource="{$productionPidUriValue}" />
      </xsl:when>
      <xsl:when test="creator/guid!=''">
        <sdo:contributor rdf:resource="{$baseUri}/{translate(creator/guid, '-', '')}" />
      </xsl:when>
      <xsl:when test="$creatorSourceUri != '' and (starts-with($creatorSourceUri, 'http://') or starts-with($creatorSourceUri, 'https://') or starts-with($creatorSourceUri, 'urn:') or starts-with($creatorSourceUri, 'ark:'))">
        <sdo:contributor rdf:resource="{$creatorSourceUri}" />
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$productionPlacePidUriValue != '' and (starts-with($productionPlacePidUriValue, 'http://') or starts-with($productionPlacePidUriValue, 'https://') or starts-with($productionPlacePidUriValue, 'urn:') or starts-with($productionPlacePidUriValue, 'ark:'))">
        <sdo:locationCreated rdf:resource="{$productionPlacePidUriValue}" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="production.place/guid/text() != ''">
            <sdo:locationCreated rdf:resource="{$baseUri}/{translate(production.place/guid, '-', '')}" />
          </xsl:when>
          <xsl:when test="normalize-space(production.place/term) != ''">
            <sdo:locationCreated rdf:resource="{$baseUri}/{translate(ancestor::record[1]/guid, '-', '')}#production-place-{count(preceding-sibling::Production) + 1}" />
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="emit-agent">
    <xsl:param name="about" />
  <xsl:param name="name" />
  <xsl:param name="isInst" />

  <xsl:choose>
      <xsl:when test="$isInst">
        <sdo:Organization rdf:about="{$about}">
          <sdo:name>
            <xsl:value-of select="$name" />
          </sdo:name>
        </sdo:Organization>
      </xsl:when>
      <xsl:otherwise>
        <sdo:Person rdf:about="{$about}">
          <sdo:name>
            <xsl:value-of select="$name" />
          </sdo:name>
        </sdo:Person>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Production" mode="StandAlone">
    <xsl:variable name="isInst" select="./name.type/value[@lang='neutral']='INST'" />
    <xsl:variable name="productionPidUri"
      select=".//PIDother/PID_other.URI
      | .//PIDother/PID_other_URI
      | .//PIDdata/PID_data.URI
      | .//PIDdata/PID_data_URI
      | .//PID_other.URI
      | .//PID_other_URI
      | .//PID_data.URI
      | .//PID_data_URI" />
    <xsl:variable name="productionPlacePidUri"
      select="production.place/PIDother/PID_other.URI
      | production.place/PIDother/PID_other_URI
      | production.place/PIDdata/PID_data.URI
      | production.place/PIDdata/PID_data_URI
      | production.place/PID_other.URI
      | production.place/PID_other_URI
      | production.place/PID_data.URI
      | production.place/PID_data_URI" />
    <xsl:variable name="productionPidUriValue" select="normalize-space($productionPidUri)" />
    <xsl:variable name="productionPlacePidUriValue" select="normalize-space($productionPlacePidUri)" />
    <xsl:variable name="creatorSourceUri" select="normalize-space(creator/Source/source.number)" />
    <xsl:choose>
      <xsl:when test="$productionPidUriValue != '' and (starts-with($productionPidUriValue, 'http://') or starts-with($productionPidUriValue, 'https://') or starts-with($productionPidUriValue, 'urn:') or starts-with($productionPidUriValue, 'ark:'))">
        <xsl:call-template name="emit-agent">
          <xsl:with-param name="about" select="$productionPidUriValue" />
          <xsl:with-param name="name" select="./creator/name" />
          <xsl:with-param name="isInst" select="$isInst" />
        </xsl:call-template>
        <!-- <foaf:Agent rdf:about="{.//PIDother/PID_other.URI}">
          <foaf:name>
            <xsl:value-of select="./creator/name" />
          </foaf:name>
        </foaf:Agent> -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="creator/guid">
          <xsl:call-template name="emit-agent">
            <xsl:with-param name="about"
              select="concat($baseUri, '/', translate(creator/guid, '-', ''))" />
            <xsl:with-param name="name" select="./creator/name" />
            <xsl:with-param name="isInst" select="$isInst" />
          </xsl:call-template>
        </xsl:if>
        <xsl:if
          test="$creatorSourceUri != '' and (starts-with($creatorSourceUri, 'http://') or starts-with($creatorSourceUri, 'https://') or starts-with($creatorSourceUri, 'urn:') or starts-with($creatorSourceUri, 'ark:'))">
          <xsl:call-template name="emit-agent">
            <xsl:with-param name="about" select="$creatorSourceUri" />
            <xsl:with-param name="name" select="./creator/name" />
            <xsl:with-param name="isInst" select="$isInst" />
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>


    <xsl:choose>
      <xsl:when test="$productionPlacePidUriValue != '' and (starts-with($productionPlacePidUriValue, 'http://') or starts-with($productionPlacePidUriValue, 'https://') or starts-with($productionPlacePidUriValue, 'urn:') or starts-with($productionPlacePidUriValue, 'ark:'))">
        <sdo:Place rdf:about="{$productionPlacePidUriValue}">
          <sdo:name>
            <xsl:value-of select="production.place/term" />
          </sdo:name>
        </sdo:Place>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="production.place/guid/text() != ''">
            <sdo:Place rdf:about="{$baseUri}/{translate(production.place/guid, '-', '')}">
              <sdo:name>
                <xsl:value-of select="production.place/term" />
              </sdo:name>
            </sdo:Place>
          </xsl:when>
          <xsl:when test="normalize-space(production.place/term) != ''">
            <sdo:Place rdf:about="{$baseUri}/{translate(ancestor::record[1]/guid, '-', '')}#production-place-{count(preceding-sibling::Production) + 1}">
              <sdo:name>
                <xsl:value-of select="production.place/term" />
              </sdo:name>
            </sdo:Place>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>
