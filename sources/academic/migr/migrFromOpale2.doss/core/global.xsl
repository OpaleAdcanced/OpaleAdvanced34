<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" 
		xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive"
		xmlns:op="utc.fr:ics/opale3"
		xmlns:xalan="http://xml.apache.org/xalan">
	<xsl:output encoding="UTF-8" method="xml"/>

	<xsl:template match="/*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- ### 
		   # Renommages 
		   ### -->
	<xsl:template match="sp:introduction">
		<sp:intro>
			<xsl:apply-templates select="@*|node()"/>
		</sp:intro>
	</xsl:template>
	<xsl:template match="sp:conclusion">
		<sp:conclu>
			<xsl:apply-templates select="@*|node()"/>
		</sp:conclu>
	</xsl:template>
	<xsl:template match="sp:division | sp:subdivision">
		<sp:div>
			<xsl:apply-templates select="@*|node()"/>
		</sp:div>
	</xsl:template>
	<xsl:template match="sp:question">
		<sp:quest>
			<xsl:apply-templates select="@*|node()"/>
		</sp:quest>
	</xsl:template>
	<xsl:template match="sp:description">
		<sp:desc>
			<xsl:apply-templates select="@*|node()"/>
		</sp:desc>
	</xsl:template>
	
	<!-- ### 
		   # Traitement des sp:Ua
		   ### -->
	<xsl:template match="sp:Ua">
		<xsl:variable name="vSubModelType"><xsl:call-template name="tGetSubModelType"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$vSubModelType='GeneralUa' or $vSubModelType='CourseUa' or $vSubModelType='courseUa'"><!-- Le contenu fils a pu être traité précedemment -->
				<sp:courseUa>
					<xsl:apply-templates select="@*|node()"/>
				</sp:courseUa>
			</xsl:when>
			<xsl:when test="$vSubModelType='AutoevaluationUa' or $vSubModelType='assmntUa'"><!-- Le contenu fils a pu être traité précedemment -->
				<sp:assmntUa>
					<xsl:apply-templates select="@*|node()"/>
				</sp:assmntUa>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">Une activité (Ua) est de type inconnu : '<xsl:value-of select="$vSubModelType"/>'. </xsl:with-param>
					<xsl:with-param name="pType" select="'error'"/>
				</xsl:call-template>
				<xsl:comment>
					Activité de type inconnu (<xsl:value-of select="$vSubModelType"/>) :
					<xsl:copy-of select="."/>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ###
		   # Traitement des sp:CourseUc
		   ### -->
	<xsl:template match="sp:CourseUc">
		<xsl:variable name="vSubModelType"><xsl:call-template name="tGetSubModelType"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$vSubModelType='PracticeUc' or $vSubModelType='practUc'"><!-- Le fichier a déja pu être transformé précédemment -->
				<sp:practUc>
					<xsl:apply-templates select="@*|node()"/>
				</sp:practUc>
			</xsl:when>
			<xsl:when test="$vSubModelType='ExpositionUc'  or $vSubModelType='expUc'"><!-- Le fichier a déja pu être transformé précédemment -->
				<sp:courseUc>
					<xsl:apply-templates select="@*|node()"/>
				</sp:courseUc>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">Une contenu (Uc) est de type inconnu : '<xsl:value-of select="$vSubModelType"/>'. </xsl:with-param>
					<xsl:with-param name="pType" select="'error'"/>
				</xsl:call-template>
				<xsl:comment>
					Contenu (Uc) de type inconnu (<xsl:value-of select="$vSubModelType"/>) :
					<xsl:copy-of select="."/>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="op:title[parent::sp:CourseUc or parent::sp:Ua]">
		<xsl:variable name="vSTitle" select="."/>
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">La surcharge des titres n'est plus autorisée dans Opale3. Le titre '<xsl:value-of select="normalize-space($vSTitle)"/>' a été supprimé.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:comment>La surcharge des titres n'est plus autorisée dans Opale3. Le titre '<xsl:value-of select="normalize-space($vSTitle)"/>' a été supprimé.</xsl:comment>
	</xsl:template>
	
	<!-- ###
		   # Traitement des sp:exercise
		   ### -->
	<xsl:template match="sp:exercise">
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
			<xsl:when test="$vSubModelType='classificationUc'">
				<xsl:if test="@sc:refUri">
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">Un changement de structure des 'ordonnancements' a imposé son internalisation lors de la migration (l'item '<xsl:value-of select="@sc:refUri"/>' n'est donc plus utilisé).</xsl:with-param>
						<xsl:with-param name="pType" select="'warning'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="xalan:nodeset($vSubModelDom)/*/op:clozeUc/sp:question">
					<sp:trainUc>
						<op:trainUc>
							<xsl:call-template name="tShowMessage">
								<xsl:with-param name="pMessage" select="'Un titre obligatoire doit être spécifié (exercice intéractif)'"/>
								<xsl:with-param name="pType" select="'error'"/>
							</xsl:call-template>
							<op:uM>
								<sp:title><xsl:value-of select="../op:dublinCore/sp:title"/><xsl:if test="count(../sp:question) &gt; 1">  (<xsl:value-of select="count(preceding-sibling::sp:question) + 1"/>)</xsl:if></sp:title>
							</op:uM>
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
						</op:trainUc>
					</sp:trainUc>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$vSubModelType='clozeUc'">
				<xsl:if test="@sc:refUri">
					<xsl:call-template name="tShowMessage">
						<xsl:with-param name="pMessage">Un changement de structure des TAT a imposé son internalisation lors de la migration (l'item '<xsl:value-of select="@sc:refUri"/>' n'est donc plus utilisé).</xsl:with-param>
						<xsl:with-param name="pType" select="'warning'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="xalan:nodeset($vSubModelDom)/*/op:clozeUc/sp:question">
					<sp:trainUc>
						<op:trainUc>
							<xsl:call-template name="tShowMessage">
								<xsl:with-param name="pMessage" select="'Un titre obligatoire doit être spécifié (exercice intéractif)'"/>
								<xsl:with-param name="pType" select="'error'"/>
							</xsl:call-template>
							<op:uM>
								<sp:title><xsl:value-of select="../op:dublinCore/sp:title"/><xsl:if test="count(../sp:question) &gt; 1">  (<xsl:value-of select="count(preceding-sibling::sp:question) + 1"/>)</xsl:if></sp:title>
							</op:uM>
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
						</op:trainUc>
					</sp:trainUc>
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
					<sp:trainUc>
						<op:trainUc>
							<xsl:call-template name="tShowMessage">
								<xsl:with-param name="pMessage" select="'Un titre obligatoire doit être spécifié (exercice intéractif)'"/>
								<xsl:with-param name="pType" select="'error'"/>
							</xsl:call-template>
							<op:uM>
								<sp:title><xsl:value-of select="../op:dublinCore/sp:title"/><xsl:if test="count(../sp:question) &gt; 1">  (<xsl:value-of select="count(preceding-sibling::sp:question) + 1"/>)</xsl:if></sp:title>
							</op:uM>
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
						</op:trainUc>
					</sp:trainUc>
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
					<sp:trainUc>
						<op:trainUc>
							<xsl:call-template name="tShowMessage">
								<xsl:with-param name="pMessage" select="'Un titre obligatoire doit être spécifié (exercice intéractif)'"/>
								<xsl:with-param name="pType" select="'error'"/>
							</xsl:call-template>
							<op:uM>
								<sp:title><xsl:value-of select="../op:dublinCore/sp:title"/><xsl:if test="count(../sp:question) &gt; 1"> (<xsl:value-of select="count(preceding-sibling::sp:question) + 1"/>)</xsl:if></sp:title>
							</op:uM>
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
						</op:trainUc>
					</sp:trainUc>
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
	
	<xsl:template match="sc:choices/sc:choice[ancestor::op:mcq]">
		<xsl:variable name="vSolution">
			<xsl:choose>
				<xsl:when test="@scoreIfSelected &gt; @scoreIfUnselected">checked</xsl:when>
				<xsl:otherwise>unchecked</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<sc:choice>
			<xsl:attribute name="solution"><xsl:value-of select="normalize-space($vSolution)"/></xsl:attribute>
			<xsl:call-template name="tShowMessage">
				<xsl:with-param name="pMessage">Les règles de scoring d'un QCM ont été modifiées dans Opale3. Les valeurs "nb de points si coché = <xsl:value-of select="@scoreIfSelected"/>" et "nb de points si non coché = <xsl:value-of select="@scoreIfUnselected"/>" ont été transformés en "solution = <xsl:value-of select="normalize-space($vSolution)"/>".</xsl:with-param>
				<xsl:with-param name="pType" select="'error'"/>
			</xsl:call-template>
			<xsl:apply-templates select="node()"/>
		</sc:choice>
	</xsl:template>
		
	<xsl:template match="op:resources[(ancestor::op:mcq or ancestor::op:scq) and name(..)!='sc:question' and name(..)!='sc:globalExplanation']">
		<!-- resources à transformer en txt -->
		<op:txt>
			<xsl:for-each select="sp:text/op:text">
				<xsl:apply-templates select="node()"/>
			</xsl:for-each>
			<!-- Les autres éléments non textuels ne sont pas récupérés -->
			<xsl:for-each select="*[name()!='sp:text']">
				<xsl:comment>Ressource de type '<xsl:value-of select="local-name()"/>' supprimée lors de la migration<xsl:if test="@sc:refUri"> (<xsl:value-of select="@sc:refUri"/>)</xsl:if>.</xsl:comment>
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pMessage">Une ressource de type '<xsl:value-of select="local-name()"/>' n'est plus autorisée dans un QCM. Elle a été supprimée<xsl:if test="@sc:refUri"> (<xsl:value-of select="@sc:refUri"/>)</xsl:if>.</xsl:with-param>
					<xsl:with-param name="pType" select="'error'"/>
				</xsl:call-template>
			</xsl:for-each>
		</op:txt>
	</xsl:template>
		
	<!-- ###
		   # Divers
		   ### -->
	
	<xsl:template match="sp:generalReference">
		<!-- Traitées de façon globales (centralisées dans les items de plus haut niveau) -->
	</xsl:template>
	<xsl:template match="sp:synthesisQuestions">
		<!-- Traitées de façon globales (centralisées dans les items de plus haut niveau) -->
	</xsl:template>
	
	<xsl:template match="/sc:item/op:synthesisQuestionItem | /sc:item/op:mcqUc | /sc:item/op:ScqUc"><!-- traité dans les items appelants. L'item est obsolète -->
		<xsl:call-template name="tShowMessage">
			<xsl:with-param name="pMessage">Cet item n'est plus utilisé.</xsl:with-param>
			<xsl:with-param name="pType" select="'warning'"/>
		</xsl:call-template>
		<xsl:comment>
			ATTENTION : cet item n'est plus utilisé
		</xsl:comment>
		<xsl:copy-of select="."/>
	</xsl:template>
			
	<!-- ### 
		   # Cas général : on copie
		   ### -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
		
</xsl:stylesheet>
