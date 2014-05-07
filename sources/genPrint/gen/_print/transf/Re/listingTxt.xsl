<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="sc sp">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:param name="vArguments"/>
	<xsl:template match="*">
		<xsl:choose>
			<xsl:when test="$vArguments">
				<xsl:variable select="local-name($vArguments)" name="vTagName"/>
				<xsl:choose>
					<xsl:when test="$vTagName='para' or $vTagName='simpleList' or $vTagName='itemizedList' or $vTagName='orderedList' or $vTagName='table' or $vTagName='extBlock' or $vTagName='emptyBlock'">
						<xsl:apply-templates select="$vArguments/node()" mode="bk"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$vArguments/node()" mode="in"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*" mode="bk"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template mode="bk" match="*"/>
	<xsl:template mode="bk" match="text()"/>
	<xsl:template mode="in" match="*"/>
	<xsl:template mode="in" match="text()">
		<xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="."/>
			<xsl:with-param name="replace" select="' '"/>
			<xsl:with-param name="by" select="' '"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template mode="bk" match="sc:para">
		<p class="op_listingTxt_p">
			<xsl:apply-templates mode="in"/>
		</p>
	</xsl:template>
	<xsl:template mode="in" match="sc:textLeaf[@role='note']">
		<span class="op_listingTxt_tl_note">
			<xsl:apply-templates mode="in"/>
		</span>
	</xsl:template>
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:copy-of select="substring-before($text,$replace)"/>
				<xsl:copy-of select="$by"/>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="substring-after($text,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>