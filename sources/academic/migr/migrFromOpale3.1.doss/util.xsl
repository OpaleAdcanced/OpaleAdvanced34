<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sc="http://www.utc.fr/ics/scenari/v3/core"
	xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:op="utc.fr:ics/opale3"
	xmlns:xalan="http://xml.apache.org/xalan" xmlns:redirect="http://xml.apache.org/xalan/redirect"
	extension-element-prefixes="xalan redirect">

	<xsl:param name="pWspPath"/>
	<xsl:param name="pTraceFilePath"/>
	<xsl:param name="pCurrentItemUri"/>
	
	<!-- ### 
           # Retourne le local-name() du modèle fils (internalisé ou externalisé)
           ### -->
	<xsl:template name="tGetSubModelType">
		<xsl:variable name="pElement" select="." />
		<xsl:choose>
			<xsl:when test="$pElement/@sc:refUri">
				<!-- item externalisé -->
				<xsl:value-of select="local-name(document(concat($pWspPath,'/',$pElement/@sc:refUri))/*/*[1])"
				/>
			</xsl:when>
			<xsl:otherwise>
				<!-- item internalisé -->
				<xsl:value-of select="local-name($pElement/*[1])" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ###
           # Permet de remplir le fichier de traces des traitements
           ### -->
	<xsl:template name="tShowMessage">
		<xsl:param name="pMessage" />
		<xsl:param name="pLevel" />
		<!-- [warning|error] -->
		<xsl:variable name="vPrefix">
			<xsl:choose>
				<xsl:when test="$pLevel='warning'">- ATTENTION : </xsl:when>
				<xsl:when test="$pLevel='error'">- ERREUR : </xsl:when>
				<xsl:otherwise>- </xsl:otherwise>
			</xsl:choose>
			<xsl:text>[</xsl:text>
			<xsl:value-of select="$pCurrentItemUri" />
			<xsl:text>] </xsl:text>
		</xsl:variable>
		<redirect:write file="{$pTraceFilePath}" append="true">
			<log>
				<xsl:value-of select="concat($vPrefix, $pMessage)" />
			</log>
		</redirect:write>
	</xsl:template>

	<xsl:template name="tExtension">
		<xsl:param name="pFilename" />
		
		<!-- Appel récursif du patron tant que l'extension contient un point -->
		<xsl:variable name="vExtension" select="substring-after($pFilename, '.')" />
		<xsl:choose>
			<xsl:when test="contains($vExtension,'.')">
				<xsl:call-template name="tExtension">
					<xsl:with-param name="pFilename" select="$vExtension" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$vExtension" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="tChangeExtension">
		<xsl:param name="pFilename" />
		<xsl:param name="pNewExtension" select="false()" />
		
		<xsl:variable name="vExtension">
			<xsl:call-template name="tExtension">
				<xsl:with-param name="pFilename" select="$pFilename" />
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$pNewExtension">
				<xsl:value-of
					select="concat(substring($pFilename, 1, string-length($pFilename) - string-length($vExtension)), $pNewExtension)"
				/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="substring($pFilename, 1, string-length($pFilename) - string-length($vExtension) - 1)"
				/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ### 
		# Cas général : on copie
		### -->
<!--	<xsl:template match="@*|node()" priority="-1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>-->
</xsl:stylesheet>
