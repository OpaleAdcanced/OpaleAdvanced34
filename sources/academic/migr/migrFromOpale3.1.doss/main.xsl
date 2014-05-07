<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sc="http://www.utc.fr/ics/scenari/v3/core"
	xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:op="utc.fr:ics/opale3"
	xmlns:xalan="http://xml.apache.org/xalan" xmlns:redirect="http://xml.apache.org/xalan/redirect"
	extension-element-prefixes="xalan redirect">

	<xsl:import href="util.xsl" />

	<xsl:output encoding="UTF-8" method="xml" />

	<xsl:param name="pWspPath" />

	<xsl:template match="sp:trainUc[@sc:refUri]">
		<xsl:variable name="vTrainUcFile" select="concat($pWspPath,'/',@sc:refUri)" />
		<xsl:variable name="vTrainUc" select="document($vTrainUcFile)/sc:item/op:*" />

		<xsl:choose>
			<!-- TrainUc non converti : le quiz est externalisé -->
			<xsl:when test="$vTrainUc[self::op:trainUc]">
				<xsl:call-template name="tQuizPart">
					<xsl:with-param name="pQuizRefUri" select="$vTrainUc/sp:quiz/@sc:refUri" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tQuizPart">
					<xsl:with-param name="pQuizRefUri" select="@sc:refUri" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="sp:trainUc[op:trainUc]">
		<xsl:call-template name="tQuizPart">
			<xsl:with-param name="pQuizRefUri" select="op:trainUc/sp:quiz/@sc:refUri" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="sp:trainUc">
		<xsl:variable name="vPartName">
			<xsl:call-template name="tQuizPartName">
				<xsl:with-param name="pQuizType" select="local-name(op:*)" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:element name="sp:{$vPartName}">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<xsl:template name="tQuizPart">
		<xsl:param name="pQuizRefUri" />

		<xsl:variable name="vQuizFile" select="concat($pWspPath,'/',$pQuizRefUri)" />
		<xsl:variable name="vQuiz" select="document($vQuizFile)/sc:item/op:*" />

		<xsl:variable name="vPartName">
			<xsl:call-template name="tQuizPartName">
				<xsl:with-param name="pQuizType" select="local-name($vQuiz)" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:element name="sp:{$vPartName}">
			<xsl:attribute name="sc:refUri">
				<xsl:call-template name="tChangeExtension">
					<xsl:with-param name="pFilename" select="$pQuizRefUri" />
					<xsl:with-param name="pNewExtension">quiz</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template name="tQuizPartName">
		<xsl:param name="pQuizType" />

		<xsl:value-of
			select="concat('trainUc', translate(substring($pQuizType,1,1),'cfmo','CFMO'), substring($pQuizType,2))"
		 />
	</xsl:template>

	<xsl:template match="op:cloze | op:field | op:match | op:mcqMur | op:mcqSur | op:ordWord">
		<xsl:copy>
			<xsl:if test="not(op:exeM)">
				<op:exeM />
			</xsl:if>
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="op:practUc/op:uM">
		<op:exeM>
			<xsl:apply-templates select="*[not(self::sp:sTitle)]" />
			<xsl:if test="sp:sTitle">
				<xsl:call-template name="tShowMessage">
					<xsl:with-param name="pLevel">warning</xsl:with-param>
					<xsl:with-param name="pMessage">
						<xsl:text>Le titre court de l'exercice "</xsl:text>
						<xsl:value-of select="sp:title" />
						<xsl:text>" a été perdu</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</op:exeM>
	</xsl:template>

	<xsl:template match="op:txtRes/sp:res">
		<sp:img>
			<xsl:apply-templates select="node() | @*" />
		</sp:img>
	</xsl:template>

	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
