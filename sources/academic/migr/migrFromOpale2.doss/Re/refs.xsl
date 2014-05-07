<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<!-- # spReference -->
	<xsl:template match="op:spReference">
		<op:genRef>
			<xsl:apply-templates select="@*|node()"/>
		</op:genRef>
	</xsl:template>
		
	<!-- # acronyme -->
	<xsl:template match="op:acronyme">
		<op:acr>
			<xsl:apply-templates select="@*|node()"/>
		</op:acr>
	</xsl:template>
	
	<xsl:template match="op:entreeAcronyme">
		<op:acrM>
			<xsl:apply-templates select="@*|node()"/>
		</op:acrM>
	</xsl:template>
	<xsl:template match="sp:acronymeTitle">
		<sp:acr>
			<xsl:apply-templates select="@*|node()"/>
		</sp:acr>
	</xsl:template>
	<xsl:template match="sp:acronymeContent">
		<sp:desc>
			<xsl:call-template name="tShowMessage">
				<xsl:with-param name="pMessage">L'élément 'Signification' d'une abréviation (acronyme) ne peut contenir que du texte dans Opale3.</xsl:with-param>
				<xsl:with-param name="pType" select="'warning'"/>
			</xsl:call-template>
			<xsl:value-of select="normalize-space(.)"/>
		</sp:desc>
	</xsl:template>
	
	<!-- # articleCode -->
	<xsl:template match="op:articleCode">
		<op:ref>
			<xsl:apply-templates select="@*|node()"/>
		</op:ref>
	</xsl:template>
	<xsl:template match="op:entreeArticleCode">
		<op:refM>
			<xsl:apply-templates select="@*|node()"/>
		</op:refM>
	</xsl:template>
	<xsl:template match="sp:codeArticleTitle">
		<sp:ref>
			<xsl:apply-templates select="@*|node()"/>
		</sp:ref>
	</xsl:template>
	<xsl:template match="sp:codeArticleContent">
		<sp:desc>
			<op:sTxt>
				<xsl:for-each select="../sp:codeArticleType">
					<sc:para>
						<xsl:choose>
							<xsl:when test="text()='ca'">[Code des assurances]</xsl:when>
							<xsl:when test="text()='cc'">[Code civil]</xsl:when>
							<xsl:when test="text()='cgi'">[Code général des impôts]</xsl:when>
							<xsl:when test="text()='css'">[Code de la sécurité sociale]</xsl:when>
							<xsl:when test="text()='ct'">[Code du travail]</xsl:when>
						</xsl:choose>
					</sc:para>
				</xsl:for-each>
				<xsl:apply-templates select="op:textSimple/node()"/>
			</op:sTxt>
		</sp:desc>
	</xsl:template>
	<xsl:template match="sp:codeArticleType"><!-- traité ci-dessus --></xsl:template>
	
	<!-- # glossary -->
	<xsl:template match="op:glossary">
		<op:glos>
			<xsl:apply-templates select="@*|node()"/>
		</op:glos>
	</xsl:template>
	<xsl:template match="op:entreeGlossaire">
		<op:glosM>
			<xsl:apply-templates select="@*|node()"/>
		</op:glosM>
	</xsl:template>
	<xsl:template match="sp:glossaryTitle">
		<sp:term>
			<xsl:apply-templates select="@*|node()"/>
		</sp:term>
	</xsl:template>
	<xsl:template match="sp:glossaryContent">
		<sp:def>
			<xsl:for-each select="op:resourceWithoutRef/sp:text/op:textWithoutRef">
				<op:sTxt>
					<xsl:apply-templates/>
				</op:sTxt>
			</xsl:for-each>
			<!-- Les autres éléments non textuels ne sont pas récupérés -->
			<xsl:for-each select="op:resourceWithoutRef/*[name()!='sp:text']">
				<xsl:comment>Ressource de type '<xsl:value-of select="local-name()"/>' supprimée lors de la migration<xsl:if test="@sc:refUri"> (<xsl:value-of select="@sc:refUri"/>)</xsl:if>.</xsl:comment>
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">Une ressource de type '<xsl:value-of select="local-name()"/>' n'est plus autorisée dans un glossaire. Elle a été supprimée<xsl:if test="@sc:refUri"> (<xsl:value-of select="@sc:refUri"/>)</xsl:if>.</xsl:with-param>
					<xsl:with-param name="pType" select="'error'"/>
				</xsl:call-template>
			</xsl:for-each>
		</sp:def>
	</xsl:template>
	
	<!-- # reference -->
	<xsl:template match="op:reference">
		<op:ref>
			<xsl:apply-templates select="@*|node()"/>
		</op:ref>
	</xsl:template>
	<xsl:template match="op:entreeReference">
		<op:refM>
			<xsl:apply-templates select="@*|node()"/>
		</op:refM>
	</xsl:template>
	<xsl:template match="sp:codeReference">
		<sp:ref>
			<xsl:apply-templates select="@*|node()"/>
		</sp:ref>
	</xsl:template>
	<xsl:template match="sp:referenceContent">
		<sp:desc>
			<xsl:for-each select="op:resourceWithoutRef/sp:text/op:textWithoutRef">
				<op:sTxt>
					<xsl:apply-templates/>
				</op:sTxt>
			</xsl:for-each>
			<!-- Les autres éléments non textuels ne sont pas récupérés -->
			<xsl:for-each select="op:resourceWithoutRef/*[name()!='sp:text']">
				<xsl:comment>Ressource de type '<xsl:value-of select="local-name()"/>' supprimée lors de la migration<xsl:if test="@sc:refUri"> (<xsl:value-of select="@sc:refUri"/>)</xsl:if>.</xsl:comment>
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">Une ressource de type '<xsl:value-of select="local-name()"/>' n'est plus autorisée dans une référence. Elle a été supprimée<xsl:if test="@sc:refUri"> (<xsl:value-of select="@sc:refUri"/>)</xsl:if>.</xsl:with-param>
					<xsl:with-param name="pType" select="'error'"/>
				</xsl:call-template>
			</xsl:for-each>
		</sp:desc>
	</xsl:template>
	
</xsl:stylesheet>
