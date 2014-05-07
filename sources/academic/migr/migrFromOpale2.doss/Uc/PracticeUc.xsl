<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<!-- # PracticeUc -->
	<xsl:template match="op:PracticeUc">
		<op:practUc>
			<xsl:apply-templates select="@*|node()"/>
		</op:practUc>
	</xsl:template>
	
	<xsl:template match="sp:problem">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- # PracticeUcProblem -->
	<xsl:template match="op:PracticeUcProblem">
		<xsl:apply-templates select="*[name()!='op:title']"/>
	</xsl:template>
	<xsl:template match="op:PracticeUcProblem/sp:description">
		<sp:desc>
			<xsl:if test="../op:title">
				<op:sTitle>
					<sc:fullTitle><xsl:value-of select="../op:title/sc:fullTitle"/></sc:fullTitle>
				</op:sTitle>
			</xsl:if>
			<xsl:apply-templates select="*"/>
		</sp:desc>
	</xsl:template>
	<xsl:template match="op:PracticeUcProblem/sp:question">
		<sp:quest>
			<xsl:apply-templates select="@*|node()"/>
		</sp:quest>
	</xsl:template>
	
	<!-- #PracticeUcProblemQuestion -->
	<xsl:template match="op:PracticeUcProblemQuestion">
		<op:practUcQ>
			<xsl:apply-templates select="@*|node()"/>
		</op:practUcQ>
	</xsl:template>
	<xsl:template match="sp:question[name(..)='op:PracticeUcProblemQuestion']">
		<sp:desc>
			<xsl:apply-templates select="@*|node()"/>
		</sp:desc>
	</xsl:template>
	<xsl:template match="sp:solution[name(..)='op:PracticeUcProblemQuestion']">
		<sp:sol>
			<xsl:apply-templates select="@*|node()"/>
		</sp:sol>
	</xsl:template>
	
	
</xsl:stylesheet>
