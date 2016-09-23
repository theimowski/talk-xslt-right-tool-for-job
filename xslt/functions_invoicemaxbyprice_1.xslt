<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="/invoice">
    ???
    <xsl:call-template name="maxByPrice">
        <xsl:with-param name="products" select="product" />
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="maxByPrice">
    <xsl:param name="products" />
    <xsl:copy-of select="$products[@price = max($products/@price)]" />
  </xsl:template>
</xsl:stylesheet>