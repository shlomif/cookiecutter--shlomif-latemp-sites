<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    >

    <xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/epub/docbook.xsl" />

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" />

<!-- Get rid of the revhistory element -->
<xsl:template match="d:revhistory" mode="titlepage.mode" />

  <xsl:template name="package-identifier">
    <xsl:variable name="info" select="*/*[contains(local-name(.), 'info')][1]"/>

    <xsl:choose>
      <xsl:when test="$info/d:biblioid">
        <xsl:if test="$info/d:biblioid[1][@class = 'doi' or
                                          @class = 'isbn' or
                                          @class = 'isrn' or
                                          @class = 'issn']">
          <xsl:text>urn:</xsl:text>
          <xsl:value-of select="$info/d:biblioid[1]/@class"/>
          <xsl:text>:</xsl:text>
        </xsl:if>
        <xsl:value-of select="$info/d:biblioid[1]"/>
      </xsl:when>
      <xsl:when test="$info/d:isbn">
        <xsl:text>urn:isbn:</xsl:text>
        <xsl:value-of select="$info/d:isbn[1]"/>
      </xsl:when>
      <xsl:when test="$info/d:issn">
        <xsl:text>urn:issn:</xsl:text>
        <xsl:value-of select="$info/d:issn[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$info/d:invpartnumber">
            <xsl:value-of select="$info/d:invpartnumber[1]"/>
          </xsl:when>
          <xsl:when test="$info/d:issuenum">
            <xsl:value-of select="$info[1]/d:issuenum[1]"/>
          </xsl:when>
          <xsl:when test="$info/d:productnumber">
            <xsl:value-of select="$info[1]/d:productnumber[1]"/>
          </xsl:when>
          <xsl:when test="$info/d:seriesvolnums">
            <xsl:value-of select="$info[1]/d:seriesvolnums[1]"/>
          </xsl:when>
          <xsl:when test="$info/d:volumenum">
            <xsl:value-of select="$info[1]/d:volumenum[1]"/>
          </xsl:when>
          <!-- Deprecated -->
          <xsl:when test="$info/d:pubsnumber">
            <xsl:value-of select="$info[1]/d:pubsnumber[1]"/>
          </xsl:when>
        </xsl:choose>
        <xsl:text>_</xsl:text>
        <xsl:choose>
          <xsl:when test="@id">
            <xsl:value-of select="@id"/>
          </xsl:when>
          <xsl:when test="@xml:id">
            <xsl:value-of select="@xml:id"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- TODO: Do UUIDs here -->
              <xsl:text>shlomif_id</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="d:book|
                       d:article|
                       d:part|
                       d:reference|
                       d:preface|
                       d:chapter|
                       d:bibliography|
                       d:appendix|
                       d:glossary|
                       d:section|
                       d:sect1|
                       d:sect2|
                       d:sect3|
                       d:sect4|
                       d:sect5|
                       d:refentry|
                       d:colophon|
                       d:bibliodiv[d:title]|
                       d:setindex|
                       d:index"
                mode="ncx">
    <xsl:variable name="depth" select="count(ancestor::*)"/>
    <xsl:variable name="title">
      <xsl:if test="$epub.autolabel != 0">
        <xsl:variable name="label.markup">
          <xsl:apply-templates select="." mode="label.markup" />
        </xsl:variable>
        <xsl:if test="normalize-space($label.markup)">
          <xsl:value-of
            select="concat($label.markup,$autotoc.label.separator)" />
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="." mode="title.markup" />
    </xsl:variable>

    <xsl:variable name="href">
      <xsl:call-template name="href.target.with.base.dir">
        <xsl:with-param name="context" select="/" />
        <!-- Generate links relative to the location of root file/toc.xml file -->
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="order">
      <xsl:value-of select="$depth +
                                  count(preceding::d:part|
                                  preceding::d:reference|
                                  preceding::d:book[parent::d:set]|
                                  preceding::d:preface|
                                  preceding::d:chapter|
                                  preceding::d:bibliography|
                                  preceding::d:appendix|
                                  preceding::d:article|
                                  preceding::d:glossary|
                                  preceding::d:section[not(parent::d:partintro)]|
                                  preceding::d:sect1[not(parent::d:partintro)]|
                                  preceding::d:sect2[not(ancestor::d:partintro)]|
                                  preceding::d:sect3[not(ancestor::d:partintro)]|
                                  preceding::d:sect4[not(ancestor::d:partintro)]|
                                  preceding::d:sect5[not(ancestor::d:partintro)]|
                                  preceding::d:refentry|
                                  preceding::d:colophon|
                                  preceding::d:bibliodiv[d:title]|
                                  preceding::d:index)"/>
    </xsl:variable>
    <xsl:variable name="playOrder">
        <xsl:choose>
          <xsl:when test="/*[self::d:set]">
            <xsl:value-of select="$order"/>
          </xsl:when>
          <xsl:when test="$root.is.a.chunk != '0'">
            <xsl:value-of select="$order + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$order - 0"/>
          </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>

    <xsl:variable name="id">
        <xsl:text>myididid</xsl:text>
        <xsl:value-of select="$playOrder"/>
    </xsl:variable>

    <xsl:element name="navPoint" namespace="http://www.daisy.org/z3986/2005/ncx/">
      <xsl:attribute name="id">
        <xsl:value-of select="$id"/>
      </xsl:attribute>

      <xsl:attribute name="playOrder">
        <xsl:value-of select="$playOrder"/>
      </xsl:attribute>
      <xsl:element name="navLabel" namespace="http://www.daisy.org/z3986/2005/ncx/">
        <xsl:element name="text" namespace="http://www.daisy.org/z3986/2005/ncx/"><xsl:value-of select="normalize-space($title)"/> </xsl:element>
      </xsl:element>
      <xsl:element name="content" namespace="http://www.daisy.org/z3986/2005/ncx/">
        <xsl:attribute name="src">
          <xsl:value-of select="$href"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:apply-templates select="d:book[parent::d:set]|d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:glossary|d:section|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv[d:title]|d:setindex|d:index" mode="ncx"/>
    </xsl:element>

  </xsl:template>
  <xsl:template
      match="d:set|
            d:book[parent::d:set]|
            d:book[*[last()][self::d:bookinfo]]|
            d:book[d:bookinfo]|
            d:book[*[last()][self::d:info]]|
            d:book[d:info]|
            d:article|
            d:part|
            d:reference|
            d:preface|
            d:chapter|
            d:bibliography|
            d:appendix|
            d:glossary|
            d:section|
            d:sect1|
            d:sect2|
            d:sect3|
            d:sect4|
            d:sect5|
            d:refentry|
            d:colophon|
            d:bibliodiv[d:title]|
            d:setindex|
            d:index"
      mode="opf.manifest">
    <xsl:variable name="href">
      <xsl:call-template name="href.target.with.base.dir">
        <xsl:with-param name="context" select="/" />
        <!-- Generate links relative to the location of root file/toc.xml file -->
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="id">
        <xsl:choose>
          <xsl:when test="@id">
            <xsl:value-of select="@id"/>
          </xsl:when>
          <xsl:when test="@xml:id">
            <xsl:value-of select="@xml:id"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- TODO: Do UUIDs here -->
              <xsl:text>shlomif_id</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="is.chunk">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$is.chunk != 0">
      <xsl:element namespace="http://www.idpf.org/2007/opf" name="item">
        <xsl:attribute name="id"> <xsl:value-of select="$id"/> </xsl:attribute>
        <xsl:attribute name="href"> <xsl:value-of select="$href"/> </xsl:attribute>
        <xsl:attribute name="media-type">application/xhtml+xml</xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="opf.spine">
    <xsl:variable name="is.chunk">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$is.chunk != 0">
      <xsl:element namespace="http://www.idpf.org/2007/opf" name="itemref">
        <xsl:attribute name="idref">
            <xsl:choose>
                <xsl:when test="@id">
                    <xsl:value-of select="@id"/>
                </xsl:when>
                <xsl:when test="@xml:id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- TODO: Do UUIDs here -->
                    <xsl:text>shlomif_id</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
      </xsl:element>
      <xsl:apply-templates select="*" mode="opf.spine"/>
    </xsl:if>
  </xsl:template>
  <!-- reproduciblde builds -->
  <xsl:template name="head.content.generator">
    <xsl:param name="node" select="."/>
    <meta name="generator" content="DocBook XSL Shlomif"/>
  </xsl:template>
</xsl:stylesheet>
