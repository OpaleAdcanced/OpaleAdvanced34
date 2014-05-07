<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="sc sp op" version="1.0" xmlns:op="utc.fr:ics/opale3" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="no" method="text" omit-xml-declaration="yes"/>
	<xsl:param name="vArguments"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="op:rssScReader">
		<xsl:value-of select="returnFirst(op:rssScReaderM/sp:onlineDisponibility,'no')"/>
	</xsl:template>
	<xsl:template match="* | text()"/>
</xsl:stylesheet>