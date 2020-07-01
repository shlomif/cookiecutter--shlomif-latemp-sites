<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet
    exclude-result-prefixes="d"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:d="http://docbook.org/ns/docbook"
    version='1.0'
    >
    <!--
    Remming out to avoid text on stdout:
    <xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml5/html5-element-mods.xsl"/>
    -->
    <xsl:import href="shlomif-essays-5.xsl" />

    <xsl:param name="css.decoration" select="0"></xsl:param>
    <xsl:param name="generate.id.attributes" select="0"></xsl:param>
    <xsl:param name="html.cellspacing"></xsl:param>
    <xsl:param name="html.cellpadding"></xsl:param>
    <xsl:param name="img.src.path">./</xsl:param>
    <xsl:param name="make.clean.html" select="1"></xsl:param>

    <xsl:template name="pi.dbhtml_cellpadding">
        <xsl:text/>
    </xsl:template>
    <xsl:template name="pi.dbhtml_cellspacing">
        <xsl:text/>
    </xsl:template>
    <!--
         Commented out because it does not work properly.
    <xsl:template name="anchor">
        <xsl:param name="node" select="."/>
        <xsl:param name="conditional" select="1"/>
        <xsl:variable name="id">
            <xsl:call-template name="object.id">
                <xsl:with-param name="object" select="$node"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:attribute name="id">
            <xsl:value-of select="$id" />
        </xsl:attribute>

    </xsl:template>
    -->
<xsl:template name="root.attributes">
        <xsl:attribute name="lang">
            <xsl:if test="//*/@xml:lang">
                <xsl:value-of select="//*/@xml:lang"/>
            </xsl:if>
        </xsl:attribute>
        <xsl:if test="//*/@xml:lang = 'he-IL' or //*/@xml:lang = 'ar'">
            <xsl:attribute name="dir">
                <xsl:text>rtl</xsl:text>
            </xsl:attribute>
        </xsl:if>
</xsl:template>

<xsl:template match="d:revhistory" mode="titlepage.mode">
  <xsl:variable name="numcols">
    <xsl:choose>
      <xsl:when test=".//d:authorinitials|.//d:author">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key">RevHistory</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="contents">
    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute"/>
      <table>
        <xsl:if test="$css.decoration != 0">
          <xsl:attribute name="style">
            <xsl:text>border-style:solid; width:100%;</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <!-- include summary attribute if not HTML5 -->
        <xsl:if test="$div.element != 'section'">
          <xsl:attribute name="summary">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key">revhistory</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
        <tr>
          <th align="{$direction.align.start}" valign="top" colspan="{$numcols}">
            <strong xmlns:xslo="http://www.w3.org/1999/XSL/Transform">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'RevHistory'"/>
              </xsl:call-template>
            </strong>
          </th>
        </tr>
        <xsl:apply-templates mode="titlepage.mode">
          <xsl:with-param name="numcols" select="$numcols"/>
        </xsl:apply-templates>
      </table>
    </div>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$generate.revhistory.link != 0">

      <!-- Compute name of revhistory file -->
      <xsl:variable name="file">
	<xsl:call-template name="ln.or.rh.filename">
	  <xsl:with-param name="is.ln" select="false()"/>
	</xsl:call-template>
      </xsl:variable>

      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir" select="$chunk.base.dir"/>
          <xsl:with-param name="base.name" select="$file"/>
        </xsl:call-template>
      </xsl:variable>

      <a href="{$file}">
        <xsl:copy-of select="$title"/>
      </a>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
        <xsl:with-param name="content">
        <xsl:call-template name="user.preroot"/>
          <html>
              <xsl:call-template name="root.attributes"/>
            <head>
              <xsl:call-template name="system.head.content"/>
              <xsl:call-template name="head.content">
                <xsl:with-param name="title">
                    <xsl:value-of select="$title"/>
                    <xsl:if test="../../d:title">
                        <xsl:value-of select="concat(' (', ../../d:title, ')')"/>
                    </xsl:if>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="user.head.content"/>
            </head>
            <body>
              <xsl:call-template name="body.attributes"/>
              <xsl:copy-of select="$contents"/>
            </body>
          </html>
          <xsl:text>
</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$contents"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="d:programlisting[@language]" mode='class.value'>
    <xsl:value-of select='concat("programlisting ", @language)' />
</xsl:template>
<xsl:template name="is.graphic.extension">
  <xsl:param name="ext"/>
  <xsl:variable name="lcext" select="translate($ext,                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',                                        'abcdefghijklmnopqrstuvwxyz')"/>
  <xsl:if test="$lcext = 'svg'              or $lcext = 'png'              or $lcext = 'jpeg'              or $lcext = 'jpg'              or $lcext = 'avi'              or $lcext = 'mpg'              or $lcext = 'mp4'              or $lcext = 'mpeg'              or $lcext = 'qt'              or $lcext = 'gif'              or $lcext = 'acc'              or $lcext = 'mp1'              or $lcext = 'mp2'              or $lcext = 'mp3'              or $lcext = 'mp4'              or $lcext = 'm4v'              or $lcext = 'm4a'              or $lcext = 'wav'              or $lcext = 'ogv'              or $lcext = 'ogg'              or $lcext = 'webm'              or $lcext = 'bmp'        or $lcext = 'webp'">1</xsl:if>
</xsl:template>
<!-- reproduciblde builds -->
<xsl:template name="head.content.generator">
  <xsl:param name="node" select="."/>
  <meta name="generator" content="DocBook XSL Shlomif"/>
</xsl:template>
</xsl:stylesheet>
