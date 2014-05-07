<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:redirect="com.scenari.xsldom.xalan.lib.Redirect" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="redirect" exclude-result-prefixes="sc xhtml" version="1.0">
	<xsl:output omit-xml-declaration="yes" indent="no" method="xml"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="treeContent">
		<div id="breadcrumb">
			<xsl:apply-templates/>			
		</div>	
	</xsl:template>
	<xsl:template match="entry">
		<xsl:variable name="vUrl" select="resultatDialogue(string(@dialog), 'act:')"/>
			<xsl:if test="$vUrl != 'outline.xml'">
				<a href="{$vUrl}" class="breadcrumb" data-ajax="false">
					<xsl:value-of select="@title"/>
				</a>
		</xsl:if>
		<xsl:if test="entry and descendant::entry">
			<xsl:text>></xsl:text>
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="node()"/>
</xsl:stylesheet>