<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:op="utc.fr:ics/opale3" exclude-result-prefixes="sc sp op">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="*">
		<xsl:choose>
			<xsl:when test=".//sp:index='form'">
				<span class="resTiForm">Formule</span>
			</xsl:when>
			<xsl:when test=".//sp:index='tab'">
				<span class="resTiTab">Tableau</span>
			</xsl:when>
			<xsl:when test=".//sp:index='graph'">
				<span class="resTiGraph">Graphique</span>
			</xsl:when>
			<xsl:when test=".//sp:index='anim'">
				<span class="resTiAnim">Animation</span>
			</xsl:when>
			<xsl:when test="parent::*='sp:int'">
				<span class="resTiDoc">Document</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>