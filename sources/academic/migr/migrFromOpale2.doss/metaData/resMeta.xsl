<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
		
	<xsl:template match="op:resMeta">
		<xsl:variable name="vTagMeta" select="si(	ancestor::*[local-name()='avi' or local-name()='doc' or local-name()='swf' or local-name()='flv' or local-name()='mov' or local-name()='mp3' or local-name()='ppt' or local-name()='rm' or local-name()='wmv' or local-name()='xls' or local-name()='zip' or local-name()='mpg' or local-name()='mpeg'], 
													'op:binAltM',
													'op:binM')"/>
		<xsl:element name="{$vTagMeta}">
			<xsl:apply-templates select="sp:title | sp:description"/>
			<xsl:if test="sp:creator | sp:contributor | sp:date">
				<sp:info>
					<op:infoBin>
						<sp:dc>
							<op:dc>
								<xsl:if test="sp:creator"><sp:auth><xsl:value-of select="sp:creator"/></sp:auth></xsl:if>
								<xsl:if test="sp:contributor"><sp:cont><xsl:value-of select="sp:contributor"/></sp:cont></xsl:if>
								<xsl:if test="sp:date"><sp:date><xsl:value-of select="sp:date"/></sp:date></xsl:if>
							</op:dc>
						</sp:dc>
					</op:infoBin>
				</sp:info>
			</xsl:if>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="op:resMeta/sp:shortTitle">
		<!-- pas géré dans Opale3 -->
		<xsl:comment>Le titre simple suivant n'a pas été récupéré d'Opale2 : '<xsl:value-of select="."/>'</xsl:comment>
	</xsl:template>

	<xsl:template match="sp:shortTitle">
		<sp:sTitle>
			<xsl:apply-templates select="@*|node()"/>
		</sp:sTitle>
	</xsl:template>
	
	<xsl:template match="op:resMeta/sp:description/op:textWithoutRef">
		<op:sTxt>
			<xsl:apply-templates select="@*|node()"/>
		</op:sTxt>
	</xsl:template>
	
</xsl:stylesheet>
