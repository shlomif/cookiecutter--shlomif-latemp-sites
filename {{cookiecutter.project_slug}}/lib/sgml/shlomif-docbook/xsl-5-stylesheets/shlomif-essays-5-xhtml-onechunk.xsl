<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:d="http://docbook.org/ns/docbook" version='1.0'>

    <xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml5/onechunk.xsl" />
    <xsl:import href="shlomif-essays-5-xhtml-common.xsl" />

    <!-- Avoid Generating a Table-of-Contents-->
    <xsl:param name="generate.toc"></xsl:param>

<!-- Disable the title="" attribute in sections. -->
<xsl:template name="generate.html.title">
</xsl:template>
<xsl:template name="component.title">
  <xsl:param name="node" select="."/>

  <!-- This handles the case where a component (bibliography, for example)
       occurs inside a section; will we need parameters for this? -->

  <!-- This "level" is a section level.  To compute <h> level, add 1. -->
  <xsl:variable name="level">
    <xsl:choose>
      <!-- chapters and other book children should get <h2> -->
      <xsl:when test="$node/parent::d:book">1</xsl:when>
      <xsl:when test="ancestor::d:section">
        <xsl:value-of select="count(ancestor::d:section)+1"/>
      </xsl:when>
      <xsl:when test="ancestor::d:sect5">6</xsl:when>
      <xsl:when test="ancestor::d:sect4">5</xsl:when>
      <xsl:when test="ancestor::d:sect3">4</xsl:when>
      <xsl:when test="ancestor::d:sect2">3</xsl:when>
      <xsl:when test="ancestor::d:sect1">2</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="h{$level+1}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="class">title</xsl:attribute>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template name="division.title">
    <xsl:param name="node" select="."/>


  <h2>
    <xsl:attribute name="class">title</xsl:attribute>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates select="$node" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="d:title" mode="titlepage.mode">
  <xsl:variable name="node" select="."/>
  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="level">
    <xsl:choose>
      <!-- chapters and other book children should get <h2> -->
      <xsl:when test="$node/parent::d:book">1</xsl:when>
      <xsl:when test="ancestor::d:section">
        <xsl:value-of select="count(ancestor::d:section)+2"/>
      </xsl:when>
      <xsl:when test="ancestor::d:sect5">6</xsl:when>
      <xsl:when test="ancestor::d:sect4">5</xsl:when>
      <xsl:when test="ancestor::d:sect3">4</xsl:when>
      <xsl:when test="ancestor::d:sect2">3</xsl:when>
      <xsl:when test="ancestor::d:sect1">2</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="h{$level}">
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:choose>
      <xsl:when test="$generate.id.attributes = 0">
        <a id="{$id}"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$show.revisionflag != 0 and @revisionflag">
	<span class="{@revisionflag}">
	  <xsl:apply-templates mode="titlepage.mode"/>
	</span>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="titlepage.mode"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
