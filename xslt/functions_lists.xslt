<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ol/li">
    <xsl:call-template name="richtext">
        <xsl:with-param name="bold" select="false()"/>
        <xsl:with-param name="text" select="concat('ordered: ', .)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="ul/li">
    <xsl:call-template name="richtext">
        <xsl:with-param name="bold" select="true()"/>
        <xsl:with-param name="text" select="concat('unordered: ', .)"/>
    </xsl:call-template>
  </xsl:template>
    
  <xsl:template name="richtext">
    <xsl:param name="bold" />
    <xsl:param name="text" />
    <richtext bold="{$bold}"><xsl:value-of select="$text"/></richtext>
  </xsl:template>
  
</xsl:stylesheet>