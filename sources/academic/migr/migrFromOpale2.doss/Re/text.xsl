<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:template match="op:text">
		<op:txt>
			<xsl:apply-templates select="@*|node()"/>
		</op:txt>
	</xsl:template>
	<xsl:template match="op:textSimple">
		<op:sTxt>
			<xsl:apply-templates select="@*|node()"/>
		</op:sTxt>
	</xsl:template>
	<xsl:template match="op:clozeText">
		<op:clozeTxt>
			<xsl:apply-templates select="@*|node()"/>
		</op:clozeTxt>
	</xsl:template>
	
	<!-- # uLink -->
	<xsl:template match="sc:uLink[@role='acronyme']">
		<sc:uLink role="acr" sc:refUri="{concat(substring-before(@sc:refUri, '.xml'), '.ref')}">
			<xsl:apply-templates select="node() | @*[name()!='role' and name()!='sc:refUri']"/>
		</sc:uLink>
	</xsl:template>
	<xsl:template match="sc:uLink[@role='glossaire']">
		<sc:uLink role="glos" sc:refUri="{concat(substring-before(@sc:refUri, '.xml'), '.ref')}">
			<xsl:apply-templates select="node() | @*[name()!='role' and name()!='sc:refUri']"/>
		</sc:uLink>
	</xsl:template>
	<xsl:template match="sc:uLink[@role='articleCode']">
		<sc:uLink role="ref" sc:refUri="{concat(substring-before(@sc:refUri, '.xml'), '.ref')}">
			<xsl:apply-templates select="node() | @*[name()!='role' and name()!='sc:refUri']"/>
		</sc:uLink>
	</xsl:template>
	<xsl:template match="sc:uLink[@role='biblio']">
		<sc:uLink role="bib" sc:refUri="{concat(substring-before(@sc:refUri, '.xml'), '.ref')}">
			<xsl:apply-templates select="node() | @*[name()!='role' and name()!='sc:refUri']"/>
		</sc:uLink>
	</xsl:template>
	<xsl:template match="sc:uLink[@role='reference']">
		<sc:uLink role="ref" sc:refUri="{concat(substring-before(@sc:refUri, '.xml'), '.ref')}">
			<xsl:apply-templates select="node() | @*[name()!='role' and name()!='sc:refUri']"/>
		</sc:uLink>
	</xsl:template>
	<xsl:template match="sc:uLink[@role='docLink']">
		<xsl:copy>
			<xsl:apply-templates select="@*[name()!='role']"/>
			<xsl:attribute name="role">docLnk</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- # Phrase -->
	<xsl:template match="sc:phrase[@role='quote']">
		<sc:inlineStyle role="quote">
			<xsl:apply-templates select="node()"/>
		</sc:inlineStyle>
	</xsl:template>
	
	<!-- # InlineStyle -->
	<xsl:template match="sc:inlineStyle[@role='emphasis']">
		<sc:inlineStyle role="emp">
			<xsl:apply-templates select="node()"/>
		</sc:inlineStyle>
	</xsl:template>
	<xsl:template match="sc:inlineStyle[@role='special']">
		<sc:inlineStyle role="spec">
			<xsl:apply-templates select="node()"/>
		</sc:inlineStyle>
	</xsl:template>
	<xsl:template match="sc:inlineStyle[@role='representative']">
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">La balise encadrante '<xsl:value-of select="@role"/>' n'a pu être récupérée dans Opale3.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	
	<!-- # Textleaf -->
	<xsl:template match="sc:textLeaf[@role='command']">
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">La balise encadrante '<xsl:value-of select="@role"/>' n'a pu être récupérée dans Opale3.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	
	<xsl:template match="sc:textLeaf[@role='email']">
		<sc:uLink url="{.}"><xsl:apply-templates select="node()"/></sc:uLink>
	</xsl:template>
	<xsl:template match="sc:textLeaf[@role='trademark']">
		<xsl:apply-templates select="node()"/><xsl:text>™</xsl:text>
	</xsl:template>
	<xsl:template match="sc:textLeaf[@role='registered']">
		<xsl:apply-templates select="node()"/><xsl:text>®</xsl:text>
	</xsl:template>
	<xsl:template match="sc:textLeaf[@role='copyright']">
		<xsl:apply-templates select="node()"/><xsl:text>©</xsl:text>
	</xsl:template>
	
	<xsl:template match="sc:textLeaf[@role='exposant']">
		<xsl:copy>
			<xsl:apply-templates select="@*[name()!='role']"/>
			<xsl:attribute name="role">exp</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="sc:textLeaf[@role='indice']">
		<xsl:copy>
			<xsl:apply-templates select="@*[name()!='role']"/>
			<xsl:attribute name="role">ind</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- # InlineImg  -->
	<xsl:template match="sc:inlineImg[@role='formulaInline']">
		<xsl:copy>
			<xsl:apply-templates select="@*[name()!='role']"/>
			<xsl:attribute name="role">form</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="sc:inlineImg[@role='guiicon']">
		<xsl:copy>
			<xsl:apply-templates select="@*[name()!='role']"/>
			<xsl:attribute name="role">ico</xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- # textSimple -->
	<xsl:template match="op:textSimple/sc:simpleList">
		<sc:itemizedList>
			<xsl:for-each select="sc:member">
				<sc:listItem>
					<sc:para>
						<xsl:apply-templates select="@*|node()"/>
					</sc:para>
				</sc:listItem>
			</xsl:for-each>
		</sc:itemizedList>
	</xsl:template>
		
</xsl:stylesheet>
