<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3"
		xmlns:redirect="org.apache.xalan.lib.Redirect" 
		extension-element-prefixes="redirect"
	>
	<xsl:output encoding="UTF-8" method="xml"/>
	
	
	<!-- ### 
           # Retourne tts les références générales des items fils (internalisés)
           ### -->
	<xsl:template name="tGetGeneralReferenceList">
		<xsl:if test="count(.//sp:generalReference)&gt;0">
			<sp:genRef>
				<op:genRef>
					<xsl:for-each select=".//sp:generalReference">
						<xsl:choose>
							<xsl:when test="@sc:refUri"><!-- ref gen externalisée -->
								<xsl:apply-templates select="document(concat($pWspPath,'/',@sc:refUri))//sp:referenceRefGen"/>
							</xsl:when>
							<xsl:otherwise><!-- ref gen internalisée -->
								<xsl:apply-templates select=".//sp:referenceRefGen"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</op:genRef>
			</sp:genRef>
		</xsl:if>
	</xsl:template>
	<xsl:template match="sp:referenceRefGen">
		<xsl:variable name="vSubModelType"><xsl:call-template name="tGetSubModelType"/></xsl:variable>
		<xsl:variable name="vExt">
			<xsl:choose>
				<xsl:when test="$vSubModelType='acronyme' or $vSubModelType='acr' or $vSubModelType='articleCode' or $vSubModelType='bibliographie' or $vSubModelType='bib' or $vSubModelType='glossary' or $vSubModelType='glos' or $vSubModelType='reference' or $vSubModelType='ref'">ref</xsl:when>
				<xsl:otherwise>xml</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<sp:ref sc:refUri="{concat(substring-before(@sc:refUri, '.xml'), '.', $vExt)}"/>
	</xsl:template>
	
	<!-- ### 
           # Retourne tts les références générales des items fils (internalisés)
           ### -->
	<xsl:template name="tGetSynthesisQuestionsList">
		<xsl:for-each select=".//sp:synthesisQuestions">
			<xsl:choose>
				<xsl:when test="@sc:refUri"><!-- ref gen externalisée -->
					<xsl:apply-templates select="document(concat($pWspPath,'/',@sc:refUri))//sp:synthesisQuestionItem"/>
				</xsl:when>
				<xsl:otherwise><!-- ref gen internalisée -->
					<xsl:apply-templates select=".//sp:synthesisQuestionItem"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="sp:synthesisQuestionItem">
		<xsl:choose>
			<xsl:when test="@sc:refUri"><!-- ref gen externalisée -->
				<xsl:apply-templates select="document(concat($pWspPath,'/',@sc:refUri))//sp:questionContent"/>
			</xsl:when>
			<xsl:otherwise><!-- ref gen internalisée -->
				<xsl:apply-templates select=".//sp:questionContent"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="sp:questionContent">
		<sp:quest>
			<xsl:apply-templates select="@*|node()"/>
		</sp:quest>
	</xsl:template>
	
	<!-- ### 
           # Retourne le local-name() du modèle fils (internalisé ou externalisé)
           ### -->
	<xsl:template name="tGetSubModelType">
		<xsl:choose>
			<xsl:when test="@sc:refUri"><!-- item externalisé -->
				<xsl:value-of select="local-name(document(concat($pWspPath,'/',@sc:refUri))/*/*[1])"/>
			</xsl:when>
			<xsl:otherwise><!-- item internalisé -->
				<xsl:value-of select="local-name(*[1])"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ###
           # Permet de remplir le fichier de traces des traitements
           ### -->
	<xsl:template name="tShowMessage">
		<xsl:param name="pMessage"/>
		<xsl:param name="pLevel"/><!-- [warning|error] -->
		<xsl:variable name="vPrefix">
			<xsl:choose>
				<xsl:when test="$pLevel='warning'">- ATTENTION : </xsl:when>
				<xsl:when test="$pLevel='error'">- ERREUR : </xsl:when>
				<xsl:otherwise>- </xsl:otherwise>
			</xsl:choose><xsl:text>[</xsl:text><xsl:value-of select="$pCurrentItemUri"/><xsl:text>] </xsl:text>
		</xsl:variable>
		<redirect:write file="{$pTraceFilePath}" append="true"><log><xsl:value-of select="concat($vPrefix, $pMessage)"/></log></redirect:write>
	</xsl:template>
	
		
</xsl:stylesheet>
