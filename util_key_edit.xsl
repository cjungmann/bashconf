<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="utf-8"/>

  <xsl:param name="schemaname" />
  <xsl:param name="keyname" />
  <xsl:param name="curval" />

  <xsl:variable name="schema" select="/schemalist/schema[@id=$schemaname]" />

  <xsl:variable name="nl"><xml:text>
</xml:text></xsl:variable>
  <xsl:variable name="FS" select="'|'" />
  <xsl:variable name="IFS" select="'#'" />


  <xsl:template match="/">
    <xsl:variable name="skey" select="$schema/key[@name=$keyname]" />
    <xsl:value-of select="concat('--title=', $keyname, $IFS)" />
    <xsl:apply-templates select="$skey" mode="show-text" />
    <xsl:apply-templates select="$skey" mode="make_input" />
    <xsl:apply-templates select="$skey" mode="add_data" />
    
  </xsl:template>

  <xsl:template name="replace">
    <xsl:param name="string" />
    <xsl:param name="target" />
    <xsl:param name="replacement" />

    <xsl:variable name="before" select="substring-before($string, $target)" />
    <xsl:variable name="after" select="substring-after($string, $target)" />

    <xsl:choose>
      <xsl:when test="$before">
        <xsl:variable name="tlen" select="string-length($target)" />
        <xsl:value-of select="$before" />
        <xsl:value-of select="$replacement" />
        <xsl:call-template name="replace">
          <xsl:with-param name="string" select="substring($after,$tlen)" />
          <xsl:with-param name="target" select="$target" />
          <xsl:with-param name="replacement" select="$replacement" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="key[description]" mode="show-text">
    <xsl:value-of select="concat('--text=',description,$IFS)" />
  </xsl:template>

  <xsl:template match="key[summary]" mode="show-text">
    <xsl:value-of select="concat('--text=',summary,$IFS)" />
  </xsl:template>

  <xsl:template match="key" mode="add_data">
    <xsl:value-of select="concat(' ',$curval)" />
  </xsl:template>

  <!-- string-type key -->
  <xsl:template match="key[@type='s']" mode="make_input">
    
  </xsl:template>

  <!-- array-of-strings type key -->
  <xsl:template match="key[@type='as']" mode="make_input">
    <xsl:text>--field=value</xsl:text>
    <xsl:value-of select="$IFS" />
  </xsl:template>

  <xsl:template match="key[@enum]" mode="make_input">
  </xsl:template>

  <!-- integer-type key -->
  <xsl:template match="key[@type='i']" mode="make_input">
  </xsl:template>

  <!-- unsigned integer-type key -->
  <xsl:template match="key[@type='u']" mode="make_input">
  </xsl:template>

  <!-- boolean-type key (yes/no) -->
  <xsl:template match="key[@type='b']" mode="make_input">
  </xsl:template>

  <!-- double/float-type key -->
  <xsl:template match="key[@type='d']" mode="make_input">
  </xsl:template>

  
  



</xsl:stylesheet>
