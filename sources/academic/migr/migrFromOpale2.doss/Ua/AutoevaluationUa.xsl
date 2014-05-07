<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3"
		xmlns:xalan="http://xml.apache.org/xalan">
	<xsl:output encoding="UTF-8" method="xml"/>
	
	<xsl:template match="op:AutoevaluationUa">
		<op:assmntUa>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="op:dublinCore"/>
			<xsl:apply-templates select="op:dublinCore//sp:pedagologicalObjective" mode="inItem"/>
			<xsl:apply-templates select="*[name()!='op:dublinCore']"/>
		</op:assmntUa>
	</xsl:template>
	
	<xsl:template match="op:AutoevaluationUa/sp:exercise">
		<xsl:variable name="vSubModelType"><xsl:call-template name="tGetSubModelType"/></xsl:variable>
		<xsl:variable name="vSubModelDom">
			<xsl:choose>
				<xsl:when test="@sc:refUri">
					<xsl:copy-of select="document(concat($pWspPath,'/',@sc:refUri))/sc:item[1]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$vSubModelType='clozeUc'">
				<xsl:if test="@sc:refUri">
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">Un changement de structure des TAT a imposé son internalisation lors de la migration (l'item '<xsl:value-of select="@sc:refUri"/>' n'est donc plus utilisé).</xsl:with-param>
						<xsl:with-param name="pType" select="'warning'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="xalan:nodeset($vSubModelDom)/*/op:ScqUc/sp:question">
					<sp:quiz>
						<op:cloze>
							<xsl:apply-templates select="*/node()"/>
							<xsl:apply-templates select="./../sc:globalExplanation"/><!-- Balise créée par acad2Opale à récupérer dans Opale3 -->
						</op:cloze>
					</sp:quiz>
					<xsl:if test="../sc:feedbacks/sc:feeback">
						<xsl:call-template name="tShowMessage">
							<xsl:with-param name="pMessage" select="'Les feedbacks n ont pas été conservés dans Opale3.'"/>
							<xsl:with-param name="pType" select="'error'"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$vSubModelType='classificationUc'">
				<xsl:if test="@sc:refUri">
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">Un changement de structure des 'ordonnancements' a imposé son internalisation lors de la migration (l'item '<xsl:value-of select="@sc:refUri"/>' n'est donc plus utilisé).</xsl:with-param>
						<xsl:with-param name="pType" select="'warning'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="xalan:nodeset($vSubModelDom)/*/op:ScqUc/sp:question">
					<sp:quiz>
						<op:match>
							<xsl:apply-templates select="*/node()"/>
							<xsl:apply-templates select="./../sc:globalExplanation"/><!-- Balise créée par acad2Opale à récupérer dans Opale3 -->
						</op:match>
					</sp:quiz>
					<xsl:if test="../sc:feedbacks/sc:feeback">
						<xsl:call-template name="tShowMessage">
							<xsl:with-param name="pMessage" select="'Les feedbacks n ont pas été conservés dans Opale3.'"/>
							<xsl:with-param name="pType" select="'error'"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$vSubModelType='ScqUc'">
				<xsl:if test="@sc:refUri">
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">Un changement de structure des QCU a imposé son internalisation lors de la migration (l'item '<xsl:value-of select="@sc:refUri"/>' n'est donc plus utilisé).</xsl:with-param>
						<xsl:with-param name="pType" select="'warning'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="xalan:nodeset($vSubModelDom)/*/op:ScqUc/sp:question">
					<sp:quiz>
						<op:mcqSur>
							<xsl:apply-templates select="*/node()"/>
							<xsl:apply-templates select="./../sc:globalExplanation"/><!-- Balise créée par acad2Opale à récupérer dans Opale3 -->
						</op:mcqSur>
					</sp:quiz>
					<xsl:if test="../sc:feedbacks/sc:feeback">
						<xsl:call-template name="tShowMessage">
							<xsl:with-param name="pMessage" select="'Les feedbacks n ont pas été conservés dans Opale3.'"/>
							<xsl:with-param name="pType" select="'error'"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$vSubModelType='mcqUc'">
				<xsl:if test="@sc:refUri">
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">Un changement de structure des QCM a imposé son internalisation lors de la migration (l'item '<xsl:value-of select="@sc:refUri"/>' n'est donc plus utilisé).</xsl:with-param>
						<xsl:with-param name="pType" select="'warning'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="xalan:nodeset($vSubModelDom)/*/op:mcqUc/sp:question">
					<sp:quiz>
						<op:mcqMur>
							<xsl:call-template name="tShowMessage">
								<xsl:with-param name="pMessage">Le scoring des QCM a changé. Veuillez vérifier votre QCM en conséquence.</xsl:with-param>
								<xsl:with-param name="pType" select="'warning'"/>
							</xsl:call-template>
							<xsl:apply-templates select="*/node()"/>
							<xsl:apply-templates select="./../sc:globalExplanation"/><!-- Balise créée par acad2Opale à récupérer dans Opale3 -->
						</op:mcqMur>
					</sp:quiz>
					<xsl:if test="../sc:feedbacks/sc:feeback">
						<xsl:call-template name="tShowMessage">
							<xsl:with-param name="pMessage" select="'Les feedbacks n ont pas été conservés dans Opale3.'"/>
							<xsl:with-param name="pType" select="'error'"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><!-- Elements non récupérés -->
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">Un exercice n'a pu être récupéré dans Opale3 (<xsl:value-of select="$vSubModelType"/>).</xsl:with-param>
					<xsl:with-param name="pType" select="'warning'"/>
				</xsl:call-template>
				<xsl:comment>
					Exercice non récupéré (<xsl:value-of select="$vSubModelType"/>) :
					<xsl:choose>
						<xsl:when test="@sc:refUri">
							<xsl:value-of select="@sc:refUri"/>
						</xsl:when>
						<xsl:otherwise><!-- internalisé -->
							<xsl:copy-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="op:AutoevaluationUa/sp:conclusion">
		<!-- non gérée dans Opale3 -->
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">La conclusion des activités d'auto-évaluationn n'est pas gérée dans Opale 3. Elle a été supprimée.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:comment>
			Conclusion d'une activités d'auto-évaluationn non récupérée : 
			<xsl:value-of select="."/>
		</xsl:comment>
	</xsl:template>
	
</xsl:stylesheet>
