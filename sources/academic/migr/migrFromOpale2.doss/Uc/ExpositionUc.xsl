<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<!-- # ExpositionUc -->
	<xsl:template match="op:ExpositionUc">
		<op:expUc>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="op:dublinCore"/>
			<xsl:choose>
				<!-- pas de division -->
				<xsl:when test="count(sp:subdivision|sp:division)=0">
					<sp:pb>
           				<op:pb>
           					<xsl:if test="sp:introduction">
           						<sp:info>
           							<op:pbTi><sp:title>Introduction</sp:title></op:pbTi>
           							<xsl:apply-templates select="sp:introduction/*"/>
           						</sp:info>
           					</xsl:if>
							<xsl:apply-templates select="sp:pb" mode="content"/>
							<xsl:if test="sp:conclusion">
           						<sp:info>
           							<op:pbTi><sp:title>Conclusion</sp:title></op:pbTi>
           							<xsl:apply-templates select="sp:conclusion/*"/>
           						</sp:info>
           					</xsl:if>
						</op:pb>
					</sp:pb>
				</xsl:when>
				<!-- présence de division -->
				<xsl:otherwise>
					<xsl:if test="sp:introduction">
						<sp:div>
							<op:expUcDiv>
								<op:expUcDivM>
									<sp:title>Introduction</sp:title>
								</op:expUcDivM>
								<sp:pb>
									<op:pb>
										<sp:info>
											<op:pbTi/>
											<xsl:apply-templates select="sp:introduction/*"/>
										</sp:info>
									</op:pb>
								</sp:pb>
							</op:expUcDiv>
						</sp:div>
					</xsl:if>
					<xsl:choose>
						<!-- pas d'intro. un ou plusieurs sp:pb suivi de divs -->
						<xsl:when test="name(*[2])='sp:pb'">
							<sp:pb>
								<op:pb>
									<xsl:apply-templates select="sp:pb[not(preceding-sibling::sp:division | preceding-sibling::sp:subdivision)]" mode="content"/>
								</op:pb>
							</sp:pb>
							<xsl:apply-templates select="*[name()!='sp:pb' and name()!='sp:introduction' and name()!='sp:conclusion' and name()!='op:dublinCore'] | sp:pb[preceding-sibling::sp:division | preceding-sibling::sp:subdivision]"/>
						</xsl:when>
						<xsl:otherwise><!-- Plusieurs sp:pb et pas en première position => on les transformes en div -->
							<xsl:apply-templates select="*[name()!='sp:introduction' and name()!='sp:conclusion' and name()!='op:dublinCore']"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="sp:conclusion">
						<sp:div>
							<op:expUcDiv>
								<op:expUcDivM>
									<sp:title>Conclusion</sp:title>
								</op:expUcDivM>
								<sp:pb>
									<op:pb>
										<sp:info>
											<op:pbTi/>
											<xsl:apply-templates select="sp:conclusion/*"/>
										</sp:info>
									</op:pb>
								</sp:pb>
							</op:expUcDiv>
						</sp:div>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</op:expUc>
	</xsl:template>
		
	<xsl:template match="sp:pb" mode="content">
		<xsl:apply-templates select="op:pb/*"/>
	</xsl:template>
	
	<xsl:template match="sp:pb">
		<sp:div>
			<xsl:call-template name="tShowMessage">
				<xsl:with-param name="pMessage" select="'Un contenu a du être transformé en division. Un titre est obligatoire pour une division, mais est manquant.'"/>
				<xsl:with-param name="pType" select="'error'"/>
			</xsl:call-template>
			<op:expUcDiv>
				<op:expUcDivM>
					<!-- Titre à spécifier par l'auteur -->
				</op:expUcDivM>
				<sp:pb>
					<xsl:apply-templates select="@*|node()"/>
				</sp:pb>
			</op:expUcDiv>
		</sp:div>
	</xsl:template>
		
	<!-- # ExpositionUcDivision, ExpositionUcSubdivision -->
	<xsl:template match="op:ExpositionUcDivision | op:ExpositionUcSubdivision">
		<op:expUcDiv>
			<op:expUcDivM>
				<sp:title><xsl:value-of select="op:title/sc:fullTitle"/></sp:title>
			</op:expUcDivM>
			<xsl:choose>
				<!-- pas de division -->
				<xsl:when test="count(sp:subdivision|sp:division)=0">
					<sp:pb>
           				<op:pb>
           					<xsl:if test="sp:introduction">
           						<sp:info>
           							<op:pbTi><sp:title>Introduction</sp:title></op:pbTi>
           							<xsl:apply-templates select="sp:introduction/*"/>
           						</sp:info>
           					</xsl:if>
							<xsl:apply-templates select="sp:pb" mode="content"/>
							<xsl:if test="sp:conclusion">
           						<sp:info>
           							<op:pbTi><sp:title>Conclusion</sp:title></op:pbTi>
           							<xsl:apply-templates select="sp:conclusion/*"/>
           						</sp:info>
           					</xsl:if>
						</op:pb>
					</sp:pb>
				</xsl:when>
				<!-- présence de division -->
				<xsl:otherwise>
					<xsl:if test="sp:introduction">
						<sp:div>
							<op:expUcDiv>
								<op:expUcDivM>
									<sp:title>Introduction</sp:title>
								</op:expUcDivM>
								<sp:pb>
									<op:pb>
										<sp:info>
											<op:pbTi/>
											<xsl:apply-templates select="sp:introduction/*"/>
										</sp:info>
									</op:pb>
								</sp:pb>
							</op:expUcDiv>
						</sp:div>
					</xsl:if>
					<xsl:choose>
						<!-- pas d'intro. un ou plusieurs sp:pb suivi de divs -->
						<xsl:when test="name(*[2])='sp:pb'">
							<sp:pb>
								<op:pb>
									<xsl:apply-templates select="sp:pb[not(preceding-sibling::sp:division | preceding-sibling::sp:subdivision)]" mode="content"/>
								</op:pb>
							</sp:pb>
							<xsl:apply-templates select="sp:*[name()!='sp:pb' and name()!='sp:introduction' and name()!='sp:conclusion' and name()!='op:title'] | sp:pb[preceding-sibling::sp:division | preceding-sibling::sp:subdivision]"/>
						</xsl:when>
						<xsl:otherwise><!-- Plusieurs sp:pb et pas en première position => on les transformes en div -->
							<xsl:apply-templates select="sp:*[name()!='sp:introduction' and name()!='sp:conclusion' and name()!='op:title']"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="sp:conclusion">
						<sp:div>
							<op:expUcDiv>
								<op:expUcDivM>
									<sp:title>Conclusion</sp:title>
								</op:expUcDivM>
								<sp:pb>
									<op:pb>
										<sp:info>
											<op:pbTi/>
											<xsl:apply-templates select="sp:conclusion/*"/>
										</sp:info>
									</op:pb>
								</sp:pb>
							</op:expUcDiv>
						</sp:div>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</op:expUcDiv>
	</xsl:template>
	
</xsl:stylesheet>
