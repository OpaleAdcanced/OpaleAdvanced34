<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
		
	<xsl:template match="op:dublinCore">
		<xsl:variable name="vTagMeta">
			<xsl:choose>
				<xsl:when test="name(..)='op:AcademicUe'">op:ueM</xsl:when>
				<xsl:otherwise>op:uM</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$vTagMeta}">
			<xsl:apply-templates select="sp:title | sp:shortTitle"/>
			<xsl:if test="count(sp:metadata/* | sp:date)&gt;0">
				<sp:info>
					<op:info>
						<xsl:apply-templates select="sp:metadata/sp:subjectList"/>
						<xsl:apply-templates select="sp:metadata/sp:rightsList"/>
						<xsl:apply-templates select="sp:metadata/sp:copyright"/>
						<sp:dc>
							<op:dc>
								<xsl:apply-templates select="sp:metadata/*[name()!='sp:subjectList' and name()!='sp:rightsList' and name()!='sp:copyright'] | sp:date"/>
							</op:dc>
						</sp:dc>
					</op:info>
				</sp:info>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:creatorList">
		<xsl:for-each select="sp:creator">
			<sp:auth><xsl:apply-templates select="@*|node()"/></sp:auth>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:contributorList">
		<xsl:for-each select="sp:contributor">
			<sp:cont><xsl:apply-templates select="@*|node()"/></sp:cont>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:publisherList">
		<xsl:for-each select="sp:publisher">
			<sp:publisher><xsl:apply-templates select="@*|node()"/></sp:publisher>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:description">
		<sp:desc>
			<xsl:apply-templates select="@*|node()"/>
		</sp:desc>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:subjectList">
		<sp:keywds>
			<op:keywds>
				<xsl:for-each select="sp:subject">
					<sp:keywd><xsl:value-of select="."/></sp:keywd>
				</xsl:for-each>
			</op:keywds>
		</sp:keywds>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:pedagologicalObjective">
		<xsl:if test="ancestor::op:expUc | ancestor::op:practUc"><!-- objectif pedago déja récupéré dans les ua et ue -->
			<sp:objs>
				<xsl:for-each select="sp:objective">
					<sp:obj><xsl:apply-templates select="@*|node()"/></sp:obj>
				</xsl:for-each>
			</sp:objs>
		</xsl:if>
	</xsl:template>
	<xsl:template match="op:dublinCore//sp:pedagologicalObjective" mode="inItem">
		<sp:obj>
			<op:sTxt>
				<xsl:for-each select="sp:objective">
					<sc:para><xsl:value-of select="."/></sc:para>
				</xsl:for-each>
			</op:sTxt>
		</sp:obj>
	</xsl:template>
	
	
	
	<xsl:template match="op:dublinCore//sp:language">
		<sp:lang><xsl:apply-templates select="@*|node()"/></sp:lang>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:spatialCoverage">
		<sp:cover>
			<xsl:for-each select="sp:spatial">
				<sp:spatial><xsl:apply-templates select="@*|node()"/></sp:spatial>
			</xsl:for-each>
		</sp:cover>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:rightsList">
		<xsl:for-each select="sp:rights">
			<xsl:choose><!-- On ne récupère que le premier copyright -->
				<xsl:when test="position()=1">
					<sp:cc>
						<xsl:choose>
							<xsl:when test="text()='cc1'">publicdomain</xsl:when>
							<xsl:when test="text()='cc2'">by</xsl:when>
							<xsl:when test="text()='cc3'">by-nc</xsl:when>
							<xsl:when test="text()='cc4'">by-nc-nd</xsl:when>
							<xsl:when test="text()='cc5'">by-nc-sa</xsl:when>
							<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
						</xsl:choose>
					</sp:cc>
				</xsl:when>
				<xsl:otherwise>
					<xsl:comment>Opale3 ne permet de spécifier qu'une seule licence par item. La licence "<xsl:value-of select="."/>" a donc été ignorée lors de la migration.</xsl:comment>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="count(sp:rights)&gt;1">
			<xsl:call-template name="tShowMessage">
				<xsl:with-param name="pMessage" select="'Opale3 ne permet de déclarer qu une seule licence. Seule la première a été conservée.'"/>
				<xsl:with-param name="pType" select="'warning'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:educationalLevel">
		<sp:level><xsl:apply-templates select="@*|node()"/></sp:level>
	</xsl:template>
	
	<xsl:template match="op:dublinCore//sp:copyright">
		<sp:cpyrgt>
			<op:sPara>
				<sc:para><xsl:apply-templates select="@*|node()"/></sc:para>
			</op:sPara>
		</sp:cpyrgt>
	</xsl:template>
	
</xsl:stylesheet>
