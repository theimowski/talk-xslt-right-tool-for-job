<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="http://example.com">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="ol/li">
    <xsl:copy-of select="my:richtext(false(), concat('ordered: ', .))"/>
  </xsl:template>

  <xsl:template match="ul/li">
    <xsl:copy-of select="my:richtext(concat('unordered: ', .), true())"/>
  </xsl:template>
    
  <xsl:function as="element(richtext)" name="my:richtext">
    <xsl:param as="xs:boolean" name="bold" />
    <xsl:param as="xs:string" name="text" />
    <richtext bold="{$bold}"><xsl:value-of select="$text"/></richtext>    
  </xsl:function>
  
</xsl:stylesheet>