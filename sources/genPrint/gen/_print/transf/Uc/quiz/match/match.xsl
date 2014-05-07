<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" xmlns:op="utc.fr:ics/opale3" exclude-result-prefixes="sc sp java op">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="*">
		<scBlock class="quiz ordWord">
			<hx class="quiz_ti">
				<span>
					<!-- Ce span est ajouté à chaque titre d'items pour permettre une liaison avec les tooltips des scBasket -->
					<span id="{alphaHash(concat(getIdNode(.),'_',java:nextDouble(java:java.util.Random.new())))}" itemKey="{concat(getIdNode(.),'_',java:nextDouble(java:java.util.Random.new()))}">
						<span class="prefixQuiz">￼;Exercice￼</span>
						<xsl:value-of select="si(op:exeM/sp:title,concat(' : ',op:exeM/sp:title),'')"/>
					</span>
				</span>
			</hx>
			<xsl:value-of select="getContent(currentModel(),'solTT')" disable-output-escaping="yes"/>
			<div class="quiz_co ">
				<xsl:for-each select="sc:question">
					<div class="bkBase bkQuestion">
						<div class="bkBase_co ">
							<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
						</div>
					</div>
				</xsl:for-each>
				<div class="bkBase bkMatch">
					<div class="bkBase_co ">
						<div class="matchRand">
							<xsl:variable name="vRand" select="java:com.scenari.s.fw.utils.RandomList.new()"/>
							<ol>
								<xsl:for-each select="sc:group/sc:label">
									<xsl:sort select="java:nextInt($vRand)" data-type="number"/>
									<li class="matchLbl">
										<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
										<xsl:value-of select="getContent(gotoSubModel(.//sp:desc),'')" disable-output-escaping="yes"/>
									</li>
								</xsl:for-each>
							</ol>
						</div>
						<table class="matchTable">
							<tr>
								<xsl:for-each select="sc:group/sc:target">
									<td class="matchGroup">
										<div class="matchTarget">
											<xsl:value-of select="getContent(gotoSubModel(.),'')" disable-output-escaping="yes"/>
										</div>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<xsl:for-each select="sc:group/sc:target">
									<td class="matchAnswer">
										<div class="matchTarget">
										</div>
									</td>
								</xsl:for-each>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</scBlock>
	</xsl:template>
</xsl:stylesheet>