<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:template match="op:supportWeb">
		<op:webRoot>
			<xsl:apply-templates select="@*|node()"/>
		</op:webRoot>
	</xsl:template>
	
	<xsl:template match="sp:opaleModel">
		<sp:ue>
			<xsl:apply-templates select="@*|node()"/>
		</sp:ue>
	</xsl:template>
	
	<!-- meta -->
	<xsl:template match="op:paramSupportWeb">
		<op:webRootM>
			<xsl:apply-templates select="@*|node()"/>
		</op:webRootM>
	</xsl:template>
	<xsl:template match="sp:paramTool">
		<sp:settings>
			<xsl:apply-templates select="@*|node()"/>
		</sp:settings>
	</xsl:template>
	<xsl:template match="sp:addIndex">
		<sp:glos>
			<xsl:apply-templates select="@*|node()"/>
		</sp:glos>
	</xsl:template>
	<xsl:template match="sp:addAcro">
		<sp:acr>
			<xsl:apply-templates select="@*|node()"/>
		</sp:acr>
	</xsl:template>
	<xsl:template match="sp:addRef">
		<sp:ref>
			<xsl:apply-templates select="@*|node()"/>
		</sp:ref>
	</xsl:template>
	<xsl:template match="sp:addBiblio">
		<sp:bib>
			<xsl:apply-templates select="@*|node()"/>
		</sp:bib>
	</xsl:template>
	<xsl:template match="sp:addArticleCode">
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">Les articles de code n'ont pas été repris dans Opale3.</xsl:with-param>
			<xsl:with-param name="pType" select="'error'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="sp:addQuestionSynthese">
		<sp:quest>
			<xsl:apply-templates select="@*|node()"/>
		</sp:quest>
	</xsl:template>
	
</xsl:stylesheet>
