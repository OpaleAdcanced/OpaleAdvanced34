<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:sfm="http://www.utc.fr/ics/scenari/v3/filemeta"
		xmlns:op="utc.fr:ics/opale3"
		xmlns:redirect="org.apache.xalan.lib.Redirect" 
		extension-element-prefixes="redirect"
		xmlns:xalan="http://xml.apache.org/xalan"
		exclude-result-prefixes="xalan">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:param name="pCurrentItemUri"/>
	<xsl:param name="pWspPath"/>
	
	<xsl:template match="sfm:odp/op:binM">
		<op:binAltM>
			<xsl:apply-templates />
		</op:binAltM>
	</xsl:template>
	
		
</xsl:stylesheet>
