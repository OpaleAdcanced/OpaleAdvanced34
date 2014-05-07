<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3"
		xmlns:redirect="org.apache.xalan.lib.Redirect" 
		extension-element-prefixes="redirect"
		xmlns:xalan="http://xml.apache.org/xalan"
		exclude-result-prefixes="xalan">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:param name="pCurrentItemUri"/>
	<xsl:param name="pWspPath"/>
	
	<xsl:template match="op:simu">
		
		<xsl:choose>
			<xsl:when test="sp:eweb">
				<op:eSite>
					<xsl:apply-templates select="op:binAltM"/>
					<xsl:apply-templates select="sp:eweb" />
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">
							Migration d'une simulation eweb
						</xsl:with-param>
					</xsl:call-template>
				</op:eSite>
			</xsl:when>
			<xsl:when test="sp:xmllab">
				<op:xmllabWrap>
					<xsl:apply-templates select="op:binAltM"/>
					<xsl:apply-templates select="sp:xmllab" />
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">
							Migration d'une simulation xml lab
						</xsl:with-param>
					</xsl:call-template>
				</op:xmllabWrap>
			</xsl:when>
			<xsl:when test="sp:vidind">
				<op:vidIndWrap>
					<xsl:apply-templates select="op:binAltM"/>
					<xsl:apply-templates select="sp:vidind" />
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">
							Migration d'une simulation video indexee
						</xsl:with-param>
					</xsl:call-template>
				</op:vidIndWrap>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="sp:xmllab">
		<sp:res sc:refUri="{@sc:refUri}" />
	</xsl:template>
		
	<xsl:template match="sp:vidind">
		<sp:res sc:refUri="{@sc:refUri}" />
	</xsl:template>	
		
</xsl:stylesheet>
