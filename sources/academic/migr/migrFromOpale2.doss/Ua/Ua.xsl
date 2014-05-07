<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:template match="op:GeneralUa | op:CourseUa">
		<op:courseUa>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:call-template name="tGetSynthesisQuestionsList"/>
			<xsl:call-template name="tGetGeneralReferenceList"/>
		</op:courseUa>
	</xsl:template>
	
	<xsl:template match="sp:division[name(..)='op:GeneralUa' or name(..)='op:CourseUa']">
		<!-- On supprime ce niveau -->
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">Perte du titre d'une division ('<xsl:value-of select=".//sp:title[1]"/>').</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:if test="*/sp:introduction">
			<sp:courseUc>
				<op:expUc>
					<op:uM>
						<sp:title>Introduction</sp:title>
					</op:uM>
					<sp:pb>
            			<op:pb>
                			<sp:info>
                				<op:pbTi/>
								<xsl:apply-templates select="*/sp:introduction/*"/>
							</sp:info>
						</op:pb>
					</sp:pb>
				</op:expUc>
			</sp:courseUc>
		</xsl:if>
		<xsl:apply-templates select="*/sp:CourseUc"/>
		<xsl:if test="*/sp:conclusion">
			<sp:courseUc>
				<op:expUc>
					<op:uM>
						<sp:title>Conclusion</sp:title>
					</op:uM>
					<sp:pb>
            			<op:pb>
                			<sp:info>
                				<op:pbTi/>
								<xsl:apply-templates select="*/sp:conclusion/*"/>
							</sp:info>
						</op:pb>
					</sp:pb>
				</op:expUc>
			</sp:courseUc>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
