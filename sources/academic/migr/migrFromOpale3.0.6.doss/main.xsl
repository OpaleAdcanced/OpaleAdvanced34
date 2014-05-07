<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3"
		xmlns:xalan="http://xml.apache.org/xalan"
		exclude-result-prefixes="xalan">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:param name="pWspPath"/>
	<xsl:param name="pTraceFilePath"/>
	<xsl:param name="pCurrentItemUri"/>

	<xsl:include href="core/util.xsl"/>
	
	<xsl:include href="binaries/odp.xsl"/>
	
	<xsl:include href="Re/Re.xsl"/>
	<xsl:include href="Re/simu.xsl"/>

</xsl:stylesheet>
