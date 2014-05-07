<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="mobile sc sp op java" version="1.0" xmlns:java="http://xml.apache.org/xalan/java" xmlns:mobile="http://scenari.soreha.fr/sc-mobile" xmlns:op="utc.fr:ics/opale3" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="no" method="xml" omit-xml-declaration="yes"/>
	<xsl:param name="vArguments"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:variable name="vUrl">
		<xsl:call-template name="tGetParam">
			<xsl:with-param name="pName">url</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="vBaseUrl">
		<xsl:call-template name="tGetParam">
			<xsl:with-param name="pName">baseUrl</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="vPubDate">
		<xsl:call-template name="tGetParam">
			<xsl:with-param name="pName">pubDate</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="vSmallImagette">
		<xsl:call-template name="tGetParam">
			<xsl:with-param name="pName">smallImagette</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="vLargeImagette">
		<xsl:call-template name="tGetParam">
			<xsl:with-param name="pName">largeImagette</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:template match="op:webRoot">
		<xsl:variable name="vAuthor" select="normalize-space(op:webRootM/sp:auth)"/>
		<xsl:variable name="vVersion" select="normalize-space(op:webRootM/sp:version)"/>
		<xsl:variable name="vDescription" select="normalize-space(getContent(gotoSubModel(sp:ue), 'descr'))"/>
		<xsl:if test="$vDescription">
			<description>
				<xsl:value-of select="$vDescription"/>
			</description>
		</xsl:if>
		<mobile:mobileInf>
			<xsl:if test="$vAuthor">
				<xsl:attribute name="author">
					<xsl:value-of select="$vAuthor"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vVersion">
				<xsl:attribute name="version">
					<xsl:value-of select="$vVersion"/>
				</xsl:attribute>
			</xsl:if>
			<mobile:pubType>
				<xsl:text>opale</xsl:text>
			</mobile:pubType>
			<mobile:smartphoneLink>
				<xsl:value-of select="$vUrl"/>
			</mobile:smartphoneLink>
			<xsl:variable name="vFrontCover" select="op:webRootM/sp:logo"/>
			<xsl:choose>
				<xsl:when test="$vSmallImagette=''">
					<xsl:if test="$vFrontCover">
						<xsl:variable name="vSmallThumbnail" select="parseXml(getContent(gotoSubModel($vFrontCover), 'small'))/img"/>
						<mobile:smallThumbnail url="{$vBaseUrl}/{$vSmallThumbnail/@src}"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<mobile:smallThumbnail url="{$vSmallImagette}"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$vLargeImagette=''">
					<xsl:if test="$vFrontCover">
						<xsl:variable name="vLargeThumbnail" select="parseXml(getContent(gotoSubModel($vFrontCover), 'large'))/img"/>
						<mobile:largeThumbnail url="{$vBaseUrl}/{$vLargeThumbnail/@src}"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<mobile:largeThumbnail url="{$vLargeImagette}"/>
				</xsl:otherwise>
			</xsl:choose>
			<mobile:pubDate>
				<xsl:value-of select="$vPubDate"/>
			</mobile:pubDate>
			<mobile:lastBuildDate>
				<xsl:value-of select="$vPubDate"/>
			</mobile:lastBuildDate>
		</mobile:mobileInf>
	</xsl:template>
	<!-- Utilitaires ================================================================ -->
	<!-- Récupère un paramètre passé par lors de l'appel de l'agent -->
	<xsl:template name="tGetParam">
		<xsl:param name="pName"/>
		<xsl:if test="string-length(normalize-space($pName))&gt;0 and string-length(normalize-space($vArguments))&gt;0">
			<xsl:value-of select="substring-before(substring-after($vArguments, concat($pName,'=')), ';')"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>