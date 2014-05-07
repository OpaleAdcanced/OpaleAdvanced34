<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:op="utc.fr:ics/opale3" exclude-result-prefixes="sc sp op">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="*">
		<div class="quizSol ordWord">
			<div class="quiz_ti">
				<span>Solution n°</span>
			</div>
			<div class="quiz_co ">
				<div class="bkBase bkOrdWord bkCorrections">
					<div class="bkBase_co ">
						<ol class="ordWordOrd">
							<xsl:for-each select="sc:label">
								<li class="bkOrdWordLbl">
									<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
								</li>
							</xsl:for-each>
						</ol>
					</div>
				</div>
				<xsl:for-each select="sc:globalExplanation">
					<div class="bkBase bkExplanations">
						<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
					</div>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>