<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:template match="op:richTitle">
		<xsl:if test="string-length(normalize-space(sp:principalTitle))&gt;0">
			<sp:title>
				<xsl:value-of select="sp:principalTitle"/>
			</sp:title>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="sp:information | sp:explication">
		<sp:info>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:info>
	</xsl:template>
	<xsl:template match="sp:fondamental">
		<sp:basic>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:basic>
	</xsl:template>
	<xsl:template match="sp:definition">
		<sp:def>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:def>
	</xsl:template>
	
	<xsl:template match="sp:syntax">
		<sp:syntax>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:syntax>
	</xsl:template>
	
	<xsl:template match="sp:example">
		<sp:ex>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:ex>
	</xsl:template>
	<xsl:template match="sp:remark">
		<sp:rem>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:rem>
	</xsl:template>
	<xsl:template match="sp:advice">
		<sp:adv>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:adv>
	</xsl:template>
	<xsl:template match="sp:complement">
		<sp:comp>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:comp>
	</xsl:template>
	<xsl:template match="sp:method">
		<sp:meth>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:meth>
	</xsl:template>
	<xsl:template match="sp:reminder">
		<sp:remind>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:remind>
	</xsl:template>
	<xsl:template match="sp:warning">
		<sp:warning>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:warning>
	</xsl:template>
	<xsl:template match="sp:simulation">
		<sp:simul>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:simul>
	</xsl:template>
	<xsl:template match="sp:legalText">
		<sp:legal>
			<op:pbTi><xsl:apply-templates select="op:richTitle"/></op:pbTi>
			<xsl:apply-templates select="@*|*[name()!='op:richTitle']"/>
		</sp:legal>
	</xsl:template>
	
</xsl:stylesheet>
