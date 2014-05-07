<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:template match="op:xmllabSimulation">
		<op:simu>
			<op:binAltM>
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage" select="'Un titre obligatoire doit être spécifié (ressource xmlLab)'"/>
					<xsl:with-param name="pType" select="'error'"/>
				</xsl:call-template>
			</op:binAltM>
			<xsl:apply-templates select="node()"/>
		</op:simu>
	</xsl:template>
			
</xsl:stylesheet>
