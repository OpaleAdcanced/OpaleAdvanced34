<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
	xmlns:sc="http://www.utc.fr/ics/scenari/v3/core"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="sc sp java" xmlns:java="http://xml.apache.org/xslt/java">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>

	<xsl:template match="*">
include.online=<xsl:value-of select="getContent(rootModel(), 'online')"/>
</xsl:template>

</xsl:stylesheet>
