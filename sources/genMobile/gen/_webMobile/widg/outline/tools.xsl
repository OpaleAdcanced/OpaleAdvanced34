<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:redirect="com.scenari.xsldom.xalan.lib.Redirect" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="redirect" exclude-result-prefixes="sc xhtml" version="1.0">
	<xsl:output omit-xml-declaration="yes" indent="no" method="xml"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="treeContent">
		<ul id="navList" data-role="listview" data-theme="d" data-divider-theme="d" data-mini="true" class="nav-search">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<xsl:template match="entry">
		<xsl:variable name="vOutlineClasses" select="resultatDialogue(concat(@dialog, '/outlineClasses'))"/>
		<xsl:variable name="vUrl" select="resultatDialogue(string(@dialog), 'act:')"/>
		<xsl:variable name="vDepth" select="count(ancestor::entry)"/>
		<xsl:if test="$vUrl != 'outline.xml'">
			<xsl:choose>
				<xsl:when test="@position='current'">
					<li data-theme="d" data-mini="true" data-icon="false" class="ui-btn-active mnu_tools">
						<a href="#" data-ajax="false">
							<img src="../skin/img/deco/{$vOutlineClasses}.png" class="ui-li-icon"/>
							<xsl:value-of select="@title"/>
						</a>
					</li>
				</xsl:when>
				<xsl:otherwise>
					<li data-theme="d" data-mini="true" data-icon="false">
						<a href="{$vUrl}" data-ajax="false">
							<img src="../skin/img/deco/{$vOutlineClasses}.png" class="ui-li-icon"/>
							<xsl:value-of select="@title"/>
						</a>
					</li>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="node()"/>
</xsl:stylesheet>