<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:java="http://xml.apache.org/xslt/java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:op="utc.fr:ics/opale3" exclude-result-prefixes="java sc sp op">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="*">
		<scBlock class="quiz cloze">
			<hx class="quiz_ti">
				<span>
					<!-- Ce span est ajouté à chaque titre d'items pour permettre une liaison avec les tooltips des scBasket -->
					<span id="{alphaHash(concat(getIdNode(.),'_',java:nextDouble(java:java.util.Random.new())))}" itemKey="{concat(getIdNode(.),'_',java:nextDouble(java:java.util.Random.new()))}">
						<span class="prefixQuiz">￼;Exercice￼</span>
						<xsl:value-of select="si(op:exeM/sp:title,concat(' : ',op:exeM/sp:title),'')"/>
					</span>
				</span>
			</hx>
			<xsl:if test="not(codeAgent(lookForAscendants($vDialog,'currentToRoot','op_coQuiz')))">
				<xsl:value-of select="getContent(currentModel(),'solTT')" disable-output-escaping="yes"/>
			</xsl:if>
			<div class="quiz_co ">
				<xsl:for-each select="sc:question">
					<div class="bkBase bkQuestion">
						<div class="bkBase_co ">
							<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
						</div>
					</div>
				</xsl:for-each>
				<xsl:for-each select="sc:gapText">
					<div class="bkBase bkGapText">
						<div class="bkBase_co ">
							<div class=" gapTextHide">
								<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
							</div>
						</div>
					</div>
				</xsl:for-each>
			</div>
		</scBlock>
	</xsl:template>
</xsl:stylesheet>