<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3"
		xmlns:xalan="http://xml.apache.org/xalan">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<!-- # bibliographie -->
	<xsl:template match="op:bibliographie">
		<op:bib>
			<xsl:apply-templates select="@*|node()"/>
		</op:bib>
	</xsl:template>
	<xsl:template match="op:entreeBiblio">
		<op:bibM>
			<xsl:variable name="vType" select="local-name(sp:entryBibliographyType/*)"/>
			<sp:id>
				<xsl:choose>
					<xsl:when test="$vType='monographie' or $vType='monographPart'"><xsl:value-of select=".//sp:bookTitle"/></xsl:when>
					<xsl:when test="$vType='monographContribution'"><xsl:value-of select=".//sp:partBookTitle"/></xsl:when>
					<xsl:when test="$vType='periodicArticle'"><xsl:value-of select=".//sp:articleTitle"/></xsl:when>
					<xsl:when test="$vType='webSite'"><xsl:value-of select=".//sp:homeSiteTitle"/></xsl:when>
					<xsl:when test="$vType='webPage'"><xsl:value-of select=".//sp:documentTitle"/></xsl:when>
					<xsl:when test="$vType='webArticle'"><xsl:value-of select=".//sp:articleTitle"/></xsl:when>
					<xsl:when test="$vType='congress'"><xsl:value-of select=".//sp:congressTitle"/></xsl:when>
					<xsl:when test="$vType='congressArticle'"><xsl:value-of select=".//sp:articleTitle"/></xsl:when>
					<xsl:when test="$vType='phdThesis'"><xsl:value-of select=".//sp:phdThesisTitle"/></xsl:when>
				</xsl:choose>
			</sp:id>
			<sp:type>
				<xsl:choose>
					<xsl:when test="$vType='webSite' or $vType='webPage' or $vType='webArticle'"><xsl:text>web</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>bib</xsl:text></xsl:otherwise>
				</xsl:choose>
			</sp:type>
			<sp:desc>
				<op:bibTxt>
					<xsl:apply-templates select="sp:entryBibliographyType/*"/>
				</op:bibTxt>
			</sp:desc>
		</op:bibM>
	</xsl:template>
	
	<!-- 
		<sc:para>
			<sc:textLeaf role="auth"></sc:textLeaf>
			<sc:textLeaf role="date"></sc:textLeaf>
			<sc:textLeaf role="ed"></sc:textLeaf>
		</sc:para>
	 -->
	<xsl:template match="op:monographie | op:monographPart | op:monographContribution | op:periodicArticle | op:congress | op:congressArticle | op:phdThesis | op:webSite | op:webPage | op:webArticle">
		<sc:para>
			<xsl:variable name="vContent">
				<xsl:for-each select="*[name()!='sp:consultationDate']">
					<xsl:if test="(string-length(normalize-space(text())) + count(*))&gt;0">
						<sp:TMPseparator/>
						<xsl:apply-templates select="current()"/>
					</xsl:if>
				</xsl:for-each>
				<xsl:apply-templates select="sp:consultationDate"/>
				<xsl:text>.</xsl:text>
			</xsl:variable>
			<xsl:for-each select="xalan:nodeset($vContent)/* | xalan:nodeset($vContent)/text()">
				<xsl:choose>
					<xsl:when test="name()='sp:TMPseparator' and count(preceding-sibling::sp:TMPseparator)=0"/>
					<xsl:when test="name()='sp:TMPseparator'">, </xsl:when>
					<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</sc:para>
	</xsl:template>
	<xsl:template name="tGetSeparator">
		<xsl:if test="count(preceding-sibling::*[	name()!='sp:consultationDate' or
													(name()='sp:creatorList' and count(sp:creator)&gt;0)])&gt;0">, </xsl:if><!-- pas en première position -->
	</xsl:template>
	
	<!-- pas simple; pose pb avec le . et les ,
	<xsl:template match="op:webSite | op:webPage | op:webArticle">
		<sc:para>
			<xsl:apply-templates select="sp:articleTitle | sp:documentTitle | sp:homeSiteTitle"/>
			<xsl:apply-templates select="sp:adresseWeb"/>
			<xsl:apply-templates select="*[name()!='sp:articleTitle' and name()!='sp:documentTitle' and name()!='sp:homeSiteTitle'  and name()!='sp:adresseWeb']"/>
		</sc:para>
	</xsl:template>
	 -->
	
	<xsl:template match="sp:creatorList">
		<xsl:if test="count(sp:creator)&gt;0">
			<sc:textLeaf role="auth">
				<xsl:apply-templates select="sp:creator"/>
			</sc:textLeaf>
		</xsl:if>
	</xsl:template>
	<xsl:template match="sp:creator">
		<xsl:value-of select=".//sp:autorLastName"/>&#160;<xsl:value-of select=".//sp:autorFirstName"/><xsl:if test="count(following-sibling::sp:creator)&gt;0">, </xsl:if>
	</xsl:template>
	
	<xsl:template match="sp:contributorList">
		<xsl:text>Contributeurs&#160;:&#160;</xsl:text>
		<xsl:for-each select="sp:contributor">
			<xsl:value-of select=".//sp:contributorLastName"/>&#160;<xsl:value-of select=".//sp:contributorFirstName"/><xsl:if test="count(following-sibling::sp:creator)&gt;0">, </xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="sp:bookTitle">
		<xsl:if test="string-length(normalize-space(text()))&gt;0"><sc:textLeaf role="title"><xsl:value-of select="text()"/></sc:textLeaf></xsl:if>
	</xsl:template>
	<xsl:template match="op:monographPart/sp:bookTitle">
		<xsl:if test="string-length(normalize-space(text()))&gt;0"><!-- <xsl:text>extrait de </xsl:text> --><sc:textLeaf role="title"><xsl:value-of select="text()"/></sc:textLeaf></xsl:if>
	</xsl:template>
	<xsl:template match="sp:edition">
		<xsl:if test="string-length(normalize-space(text()))&gt;0"><sc:textLeaf role="ed"><xsl:value-of select="text()"/></sc:textLeaf></xsl:if>
	</xsl:template>
	<xsl:template match="sp:publication">
		<xsl:if test="string-length(normalize-space(string(.)))&gt;0"><!-- <xsl:text>publié par </xsl:text> --><sc:textLeaf role="ed"><xsl:value-of select=".//sp:editor"/></sc:textLeaf><xsl:if test="string-length(.//sp:editor)&gt;0"><xsl:text>, </xsl:text></xsl:if><xsl:value-of select=".//sp:place"/><xsl:if test="string-length(.//sp:place) &gt;0"><xsl:text>, </xsl:text></xsl:if><sc:textLeaf role="date"><xsl:value-of select=".//sp:year"/></sc:textLeaf></xsl:if>
	</xsl:template>
	<xsl:template match="sp:publicationDate">
		<xsl:if test="string-length(normalize-space(.))&gt;0"><!--  <xsl:text>publié le </xsl:text>--><sc:textLeaf role="date"><xsl:value-of select="."/></sc:textLeaf></xsl:if>
	</xsl:template>
	<xsl:template match="sp:volumeDivision">
		<xsl:text></xsl:text><xsl:value-of select="text()"/>
	</xsl:template>
	<xsl:template match="sp:number">
		<xsl:text>n° </xsl:text><xsl:value-of select="text()"/>
	</xsl:template>
	<xsl:template match="sp:numberPages">
		<xsl:value-of select="text()"/><xsl:text>&#160;pages</xsl:text>
	</xsl:template>
	<xsl:template match="sp:collection">
		<!-- <xsl:text>collection </xsl:text> --><xsl:value-of select=".//sp:name"/>
	</xsl:template>
	<xsl:template match="sp:partTitle | sp:partBookTitle | sp:articleTitle">
		<xsl:if test="string-length(normalize-space(text()))&gt;0"><sc:textLeaf role="title"><xsl:value-of select="text()"/></sc:textLeaf><xsl:if test="../sp:pageLocalisation"><xsl:text> (p.</xsl:text><xsl:value-of select="../sp:pageLocalisation"/><xsl:text>)</xsl:text></xsl:if></xsl:if>
	</xsl:template>
	<xsl:template match="sp:pageLocalisation"><!-- Traité dans sp:partTitle | sp:partBookTitle | sp:articleTitle--></xsl:template>
	
	<xsl:template match="sp:adresseWeb">
		<sc:uLink role="url" url="{text()}"><xsl:value-of select="text()"/></sc:uLink>
	</xsl:template>
	<xsl:template match="sp:homeSiteTitle | sp:documentTitle | sp:phdThesisTitle">
		<xsl:if test="string-length(normalize-space(text()))&gt;0"><sc:textLeaf role="title"><xsl:value-of select="text()"/></sc:textLeaf></xsl:if>
	</xsl:template>
	<xsl:template match="sp:consultationDate">
		<xsl:text> (consultation </xsl:text><xsl:value-of select=".//sp:day"/><xsl:text> </xsl:text><xsl:value-of select=".//sp:month"/><xsl:text> </xsl:text><xsl:value-of select=".//sp:year"/><xsl:text>)</xsl:text>
	</xsl:template>
	
	<xsl:template match="sp:periodicTitle">
		<!-- <xsl:text>extrait du périodique </xsl:text> --><xsl:value-of select="text()"/>
	</xsl:template>

	<xsl:template match="sp:congressHeading">
		<xsl:value-of select="text()"/>
	</xsl:template>
	<xsl:template match="sp:congressTitle">
		<xsl:if test="string-length(normalize-space(text()))&gt;0"><sc:textLeaf role="title"><xsl:value-of select="text()"/></sc:textLeaf></xsl:if>
	</xsl:template>
	
	<xsl:template match="sp:domain | sp:place | sp:year">
		<xsl:value-of select="text()"/>
	</xsl:template>
		
</xsl:stylesheet>
