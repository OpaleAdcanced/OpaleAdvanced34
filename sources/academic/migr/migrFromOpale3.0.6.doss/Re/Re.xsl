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

	<xsl:template match="sp:simu">
		<xsl:variable name="vFilePathSimu">
			<xsl:value-of select="concat($pWspPath,'/',$pCurrentItemUri, '.',generate-id(), 'Simu', '.xml')"/>
		</xsl:variable>
		<xsl:variable name="vFileUriSimu">
			<xsl:value-of select="concat('/',$pCurrentItemUri, '.',generate-id(), 'Simu', '.xml')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@sc:refUri">
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">
						Simulation en partie Zoom
					</xsl:with-param>
				</xsl:call-template>
				<sp:zoom sc:refUri="{@sc:refUri}" >
					<xsl:apply-templates select="document(concat($pWspPath,'/',@sc:refUri))/*/*[1]/sp:acc" mode="intern" />
				</sp:zoom>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">
						Simulation en partie Zoom
					</xsl:with-param>
				</xsl:call-template>
				<sp:zoom sc:refUri="{$vFileUriSimu}" >
					<xsl:apply-templates select="op:simu/sp:acc" mode="intern" />
				</sp:zoom>
				<redirect:write file="{$vFilePathSimu}" append="false">
					<sc:item xmlns:sc="http://www.utc.fr/ics/scenari/v3/core">
						<xsl:choose>
							<xsl:when test="op:simu/sp:eweb">
								<xsl:call-template name="tShowMessage">
									<xsl:with-param name="pMessage">
										Création d'un eSite
									</xsl:with-param>
								</xsl:call-template>
								<op:eSite xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:op="utc.fr:ics/opale3">
									<xsl:apply-templates select="op:simu/op:binAltM" />
									<xsl:apply-templates select="op:simu/sp:eweb" />
								</op:eSite>
							</xsl:when>
							<xsl:when test="op:simu/sp:xmllab">
								<xsl:call-template name="tShowMessage">
									<xsl:with-param name="pMessage">
										Création d'un xml lab wrap
									</xsl:with-param>
								</xsl:call-template>
								<op:xmllabWrap xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:op="utc.fr:ics/opale3">
									<xsl:apply-templates select="op:simu/op:binAltM" />
									<xsl:apply-templates select="op:simu/sp:xmllab" />
								</op:xmllabWrap>
							</xsl:when>
							<xsl:when test="op:simu/sp:vidind">
								<xsl:call-template name="tShowMessage">
									<xsl:with-param name="pMessage">
										Création d'un vid ind wrap
									</xsl:with-param>
								</xsl:call-template>
								<op:vidIndWrap xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:op="utc.fr:ics/opale3">
									<xsl:apply-templates select="op:simu/op:binAltM" />
									<xsl:apply-templates select="op:simu/sp:vidind" />
								</op:vidIndWrap>
							</xsl:when>
						</xsl:choose>
					</sc:item>
				</redirect:write>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="sp:acc" mode="intern">
		<op:instructionM>
			<sp:webInstruct>
				<xsl:apply-templates select="op:res" mode="toTxt"/>
			</sp:webInstruct>
		</op:instructionM>
	</xsl:template>
		
	<xsl:template match="op:res" mode="toTxt">
		<op:txt>
			<xsl:apply-templates select=".//op:txt" mode="toTxt" />
		</op:txt>
		<xsl:apply-templates select="sp:img | sp:txtRes | sp:tab | sp:graph | sp:vid | sp:int | sp:form | sp:listing | sp:bkquote" mode="error" />
	</xsl:template>
	
	<xsl:template match="op:txt" mode="toTxt">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="sp:img | sp:txtRes | sp:tab | sp:graph | sp:vid | sp:int | sp:form | sp:listing | sp:bkquote" mode="error">
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">
				Cette ressource <xsl:value-of select="local-name()"/>  ( <xsl:value-of select="@sc:refUri"/> ) n'est plus autorisée dans ce contexte
			</xsl:with-param>
			<xsl:with-param name="pLevel">error</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
