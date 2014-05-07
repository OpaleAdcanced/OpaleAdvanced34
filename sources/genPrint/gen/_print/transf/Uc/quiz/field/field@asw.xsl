<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:op="utc.fr:ics/opale3" exclude-result-prefixes="sc sp op">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="*">
		<div class="quizSol field">
			<xsl:if test="not(codeAgent(lookForAscendants($vDialog,'currentToRoot','op_coQuiz')))">
				<div class="quiz_ti">
					<span>Solution n°</span>
				</div>
			</xsl:if>
			<div class="quiz_co ">
				<xsl:for-each select="sp:asw">
					<div class="bkBase bkAnswer">
						<div class="bkBase_co ">
							<xsl:for-each select="sc:SFSolution">
								<p class="solPara">
									<xsl:value-of select="sc:value/text()"/>
								</p>
							</xsl:for-each>
						</div>
					</div>
				</xsl:for-each>
			</div>
			<xsl:for-each select="sc:globalExplanation">
				<div class="bkBase bkExplanations">
					<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>