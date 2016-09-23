<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:my="http://example.com">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="/invoice">
    <xsl:copy-of select="my:maxByPrice(product)" />
  </xsl:template>
  <xsl:function name="my:maxByPrice">
    <xsl:param name="products" />
    <xsl:copy-of select="$products[@price = max($products/@price)]" />
  </xsl:function>
</xsl:stylesheet>