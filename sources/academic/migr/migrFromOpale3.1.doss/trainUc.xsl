<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sc="http://www.utc.fr/ics/scenari/v3/core"
    xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:op="utc.fr:ics/opale3"
    xmlns:xalan="http://xml.apache.org/xalan" xmlns:redirect="http://xml.apache.org/xalan/redirect"
    extension-element-prefixes="xalan redirect">

    <xsl:import href="util.xsl" />

    <xsl:output encoding="UTF-8" method="xml" />

    <xsl:template match="op:trainUc[sp:quiz[@sc:refUri]]">
        <xsl:variable name="vQuizFile" select="concat($pWspPath,'/',sp:quiz/@sc:refUri)" />
        <xsl:variable name="vQuiz" select="document($vQuizFile)/sc:item/op:*" />

        <!-- R�ecriture du quiz r�f�renc� avec les m�ta-donn�es de l'exercice int�ractif (si aucune m�ta-donn�es n'a d�j� �t� �crites pour le moment -->
        <xsl:choose>
            <xsl:when test="not($vQuiz/op:exeM)">
                <xsl:call-template name="tShowMessage">
                    <xsl:with-param name="pMessage">
                        <xsl:text>Les m�ta-donn�es de l'exercice int�ractif "</xsl:text>
                        <xsl:value-of select="op:uM/sp:title" />
                        <xsl:text>" ont �t� pass�es au quiz qu'il r�f�rence</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
                <redirect:write select="$vQuizFile">
                    <sc:item>
                        <xsl:apply-templates select="$vQuiz">
                            <xsl:with-param name="pMeta" select="op:uM" />
                        </xsl:apply-templates>
                    </sc:item>
                </redirect:write>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tShowMessage">
                    <xsl:with-param name="pLevel">warning</xsl:with-param>
                    <xsl:with-param name="pMessage">
                        <xsl:text>Les m�ta-donn�es de l'exercice int�ractif "</xsl:text>
                        <xsl:value-of select="op:uM/sp:title" />
                        <xsl:text>" ont �t� perdues</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Le contenu est r�ecris pour conserver la r�f�rence au quiz dans le second traitement -->
        <xsl:copy-of select="." />
    </xsl:template>

    <xsl:template match="op:trainUc">
        <xsl:apply-templates select="sp:quiz/op:*">
            <xsl:with-param name="pMeta" select="op:uM" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="op:trainUc/op:uM">
        <op:exeM>
            <xsl:apply-templates select="*[string-length(.) and not(self::sp:sTitle)]" />
        </op:exeM>
    </xsl:template>

    <xsl:template match="op:cloze | op:field | op:match | op:mcqMur | op:mcqSur | op:ordWord">
        <xsl:param name="pMeta" />

        <xsl:copy>
            <xsl:if test="string-length($pMeta)">
                <xsl:apply-templates select="$pMeta" />
            </xsl:if>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
