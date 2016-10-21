<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8"/>

  <xsl:param name="schemafile" />
  <xsl:param name="schemaname" />

  <xsl:key name="ref" match="schema/key" use="@name" />
  
  <xsl:variable
      name="lookup"
      select="document($schemafile)/schemalist/schema[@id=$schemaname]" />

  <xsl:variable name="FS" select="'|'" />
  <xsl:variable name="nl"><xsl:text>
</xsl:text></xsl:variable>

  <xsl:template match="/">
    <!-- <xsl:call-template name="column-values" /> -->
    <xsl:apply-templates select="gsettings/key">
      <xsl:sort select="@name" data-type="text" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="column-values">
    <xsl:text> --column=name</xsl:text>
    <xsl:text> --column=current</xsl:text>
    <xsl:text> --column=default</xsl:text>
  </xsl:template>

  <xsl:template match="gsettings/key">
    <xsl:variable name="t" select="." />
    <xsl:for-each select="$lookup">
      <xsl:apply-templates select="key('ref', $t/@name)">
        <xsl:with-param name="okey" select="$t" />
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="schema/key">
    <xsl:param name="okey" />
    <xsl:value-of select="concat(@name,$nl)" />
    <xsl:value-of select="concat($okey,$nl)" />
    <xsl:value-of select="concat(default,$nl)" />
  </xsl:template>


</xsl:stylesheet>
