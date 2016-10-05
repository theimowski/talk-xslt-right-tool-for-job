<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--<xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>-->
  <xsl:output encoding="UTF-8" method="text" />
  
  <xsl:template match="/invoice">
    <xsl:call-template name="sum">
      <xsl:with-param name="products" select="product" />
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="sum">
    <xsl:param name="products" />
    <xsl:param name="acc" select="0" />
    <xsl:choose>
      <xsl:when test="not($products)">
        <xsl:value-of select="$acc" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="price" select="$products[1]/@price" />
        <xsl:variable name="quantity" select="$products[1]/@quantity" />
        <xsl:call-template name="sum">
          <xsl:with-param name="products" select="$products[position() > 1]" />
          <xsl:with-param name="acc" select="$acc + ($quantity * $price)" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>