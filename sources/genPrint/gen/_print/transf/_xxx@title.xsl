<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:scOrigin="eu.scenari.gen.xslt.OriginSrc" xmlns:java="http://xml.apache.org/xslt/java" extension-element-prefixes="scOrigin" exclude-result-prefixes="java sc sp">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="*">
		<!-- Ce span est ajouté à chaque titre d'items pour permettre une liaison avec les tooltips des scBasket -->
		<span id="{alphaHash(concat(getIdNode(.),'_',java:nextDouble(java:java.util.Random.new())))}" itemKey="{concat(getIdNode(.),'_',java:nextDouble(java:java.util.Random.new()))}">
			<xsl:value-of select="si(getFullTitleText(currentModel()),getFullTitleText(currentModel()),'Sans titre')"/>
		</span>
	</xsl:template>
</xsl:stylesheet>