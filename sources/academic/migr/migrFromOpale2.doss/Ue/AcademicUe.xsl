<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:template match="op:AcademicUe">
		<op:ue>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="op:dublinCore"/>
			<xsl:apply-templates select="op:dublinCore//sp:pedagologicalObjective" mode="inItem"/>
			<xsl:apply-templates select="*[name()!='op:dublinCore']"/>
			<xsl:call-template name="tGetGeneralReferenceList"/>
		</op:ue>
	</xsl:template>
	
	<!-- divisions -->
	<xsl:template match="op:AcademicUeDivision | op:AcademicUeSubdivision">
		<op:ueDiv>
			<xsl:apply-templates select="@*|node()"/>
		</op:ueDiv>
	</xsl:template>
	<xsl:template match="op:title[name(..)='op:AcademicUeDivision' or name(..)='op:AcademicUeSubdivision']">
		<op:ueDivM>
			<xsl:if test="sc:fullTitle"><sp:title><xsl:value-of select="sc:fullTitle"/></sp:title></xsl:if>
			<xsl:if test="sc:shortTitle"><sp:sTitle><xsl:value-of select="sc:shortTitle"/></sp:sTitle></xsl:if>
		</op:ueDivM>
	</xsl:template>
	
	
</xsl:stylesheet>
