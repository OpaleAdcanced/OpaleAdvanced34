<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<!-- # resources -->
	<xsl:template match="op:resources">
		<op:res>
			<xsl:apply-templates select="@*|node()"/>
		</op:res>
	</xsl:template>
	<xsl:template match="sp:text">
		<sp:txt>
			<xsl:apply-templates select="@*|node()"/>
		</sp:txt>
	</xsl:template>
	<xsl:template match="sp:formula">
		<sp:form>
			<xsl:apply-templates select="@*|node()"/>
		</sp:form>
	</xsl:template>
	<xsl:template match="sp:table">
		<sp:tab>
			<xsl:apply-templates select="@*|node()"/>
		</sp:tab>
	</xsl:template>
	<xsl:template match="sp:vectorGraphic">
		<sp:graph>
			<xsl:apply-templates select="@*|node()"/>
		</sp:graph>
	</xsl:template>
	<xsl:template match="sp:interactiveGraphic | sp:documentOD">
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">Les ressources de type '<xsl:value-of select="local-name()"/>' n'existent plus dans Opale3.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:comment>
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:comment>
	</xsl:template>
	<xsl:template match="sp:bitmapImage">
		<sp:img>
			<xsl:apply-templates select="@*|node()"/>
		</sp:img>
	</xsl:template>
	<xsl:template match="sp:video | sp:audiovisual | sp:audio">
		<sp:vid>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</sp:vid>
	</xsl:template>
	<xsl:template match="sp:interaction">
		<xsl:choose>
			<xsl:when test="substring(@sc:refUri, string-length(@sc:refUri) - 4, 5)='.eWeb'"><!-- res "eWeb" passée dans simu -->
				<sp:simu>
					<xsl:apply-templates/><!-- alt -->
					<op:simu>
						<op:binAltM>
							<xsl:call-template name="tShowMessage">
								<xsl:with-param name="pMessage" select="'Un titre obligatoire doit être spécifié (ressource eWeb)'"/>
								<xsl:with-param name="pType" select="'error'"/>
							</xsl:call-template>
						</op:binAltM>
						<sp:eweb sc:refUri="{@sc:refUri}"/>
					</op:simu>
				</sp:simu>
			</xsl:when>
			<xsl:otherwise>
				<sp:int>
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates select="node()"/>
				</sp:int>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
			
	<!-- # altRess -->
	<xsl:template match="op:alternativeResource">
		<!-- 
		<op:altRes>
			<xsl:apply-templates select="@*|node()"/>
		</op:altRes>
		 -->
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">Les ressources alternatives sont spécifiées directement dans les métas de la ressource dans Opale3. La ressource alternative '<xsl:value-of select="."/>' a été ignorée.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:comment>
			Ressource alternative ignorée : 
			<xsl:apply-templates/>
		</xsl:comment>
	</xsl:template>
	<xsl:template match="op:altRess">
		<!-- Un seul alt autorisé dans Opale3
		<op:alt>
			<sp:alt>
				<op:altRes>
					<xsl:apply-templates select="sp:alternative/op:alternativeResource/*"/>
				</op:altRes>
			</sp:alt>
		</op:alt>
		-->
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">Les ressources alternatives sont spécifiées directement dans les métas de la ressource dans Opale3. La ressource alternative '<xsl:value-of select="."/>' a été ignorée.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:comment>
			Ressource alternative ignorée : 
			<xsl:apply-templates select="sp:alternative/op:alternativeResource/*"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- # resourceWithoutRef -->
	<xsl:template match="op:resourceWithoutRef">
		<op:res>
			<xsl:apply-templates select="@*|node()"/>
		</op:res>
	</xsl:template>
	<xsl:template match="op:resourceWithoutRef/sp:text/op:textWithoutRef">
		<op:txt>
			<xsl:apply-templates select="@*|node()"/>
		</op:txt>
	</xsl:template>
	
		
</xsl:stylesheet>
