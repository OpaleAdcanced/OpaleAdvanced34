<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:op="utc.fr:ics/opale3" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="op sc sp">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:param name="vDialog" />
	<xsl:param name="vAgent" />
	
	<xsl:template match="op:ue">
		<xsl:value-of select="normalize-space(sp:obj)" />
	</xsl:template>
	
</xsl:stylesheet>
