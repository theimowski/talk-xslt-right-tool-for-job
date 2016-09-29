<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="/invoice">
    <xsl:call-template name="add">
        <xsl:with-param name="sku" select="001" />
        <xsl:with-param name="amount" select="3" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="add">
    <xsl:param name="sku" />
    <xsl:param name="amount" />
    <invoice>
        <xsl:for-each select="product">
            <xsl:call-template name="addSingle">
                <xsl:with-param name="amount" select="if ($sku = @sku) then $amount else 0" />
            </xsl:call-template>
        </xsl:for-each>
    </invoice>
  </xsl:template>

  <xsl:template name="addSingle">
    <xsl:param name="amount" />
    <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="quantity" select="@quantity + $amount"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>