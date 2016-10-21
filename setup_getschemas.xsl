<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
   version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"
         version="1.0"
         encoding="utf-8"/>

  <xsl:variable name="nl"><xsl:text>
</xsl:text>
  </xsl:variable>
  <!-- <xsl:variable name="tab" select="'&#9;'" /> -->
  <xsl:variable name="tab" select="'&#9;'" />

  <xsl:param name="schemafile" />

  <xsl:template match="/">
    <xsl:apply-templates select="schemalist/schema" />
  </xsl:template>

  <xsl:template match="schema">
    <xsl:variable name="loctype">
      <xsl:choose>
        <xsl:when test="@path">f</xsl:when>
        <xsl:otherwise>r</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:value-of select="concat(@id, $tab, $schemafile, $tab, $loctype, $nl)" />
  </xsl:template>

  <xsl:template match="schema_test">
    <xsl:value-of select="concat(@id,$nl)" />
  </xsl:template>

</xsl:stylesheet>
