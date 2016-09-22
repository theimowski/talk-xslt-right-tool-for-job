<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="/topic">
    <sum>
        <xsl:value-of select="ul/li[matches(., '^\d+$')]!xs:integer(.) => sum()" />
    </sum>
  </xsl:template>
</xsl:stylesheet>