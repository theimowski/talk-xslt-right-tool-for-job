<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
  <xsl:template match="/topic">
    <sum>
        <xsl:call-template name="sum">
            <xsl:with-param name="nodes" select="ul/li" />
        </xsl:call-template>
    </sum>
  </xsl:template>
  <xsl:template name="sum">
    <xsl:param name="nodes" />
    <xsl:param name="acc" select="0" />
    <xsl:choose>
        <xsl:when test="not($nodes)">
            <xsl:value-of select="$acc" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="sum">
                <xsl:with-param name="nodes" select="$nodes[position() > 1]" />
                <xsl:with-param name="acc">
                    <xsl:choose>
                        <xsl:when test="matches($nodes[1], '^\d+$')">
                            <xsl:value-of select="$acc + $nodes[1]" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$acc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>