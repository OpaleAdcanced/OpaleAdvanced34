<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:redirect="com.scenari.xsldom.xalan.lib.Redirect" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="redirect" exclude-result-prefixes="sc xhtml" version="1.0">
	<xsl:output omit-xml-declaration="yes" indent="no" method="xml"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="treeContent">
		<outline>
			<xsl:apply-templates/>
		</outline>
	</xsl:template>
	<xsl:template match="entry">
		<xsl:variable name="vOutlineClasses" select="resultatDialogue(concat(@dialog, '/outlineClasses'))"/>
		<xsl:variable name="vUrl" select="resultatDialogue(string(@dialog), 'act:')"/>
		<xsl:if test="$vUrl != 'outline.xml'">
			<xsl:element name="{si(entry,'b','l')}">
				<xsl:attribute name="c">
					<xsl:value-of select="$vOutlineClasses"/>
				</xsl:attribute>
				<xsl:attribute name="u">
					<xsl:value-of select="$vUrl"/>
				</xsl:attribute>
				<xsl:attribute name="t">
					<xsl:value-of select="@title"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="node()"/>
</xsl:stylesheet>