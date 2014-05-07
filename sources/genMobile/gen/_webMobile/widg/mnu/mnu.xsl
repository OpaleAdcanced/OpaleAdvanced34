<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:redirect="com.scenari.xsldom.xalan.lib.Redirect" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" extension-element-prefixes="redirect" exclude-result-prefixes="sc xhtml" version="1.0">
	<xsl:output omit-xml-declaration="yes" indent="no" method="xml"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="treeContent">
		<ul id="navList" data-role="listview" data-theme="d" data-divider-theme="d" data-mini="true" class="nav-search">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<xsl:template match="entry">
		<xsl:variable name="vOutlineClasses" select="resultatDialogue(concat(@dialog, '/outlineClasses'))"/>
		<xsl:variable name="vUrl" select="resultatDialogue(string(@dialog), 'act:')"/>
		<xsl:param name="vDepth" select="count(ancestor::entry)"/>
		<xsl:variable name="vNbChild" select="count(child::entry)"/>
		<xsl:param name="vRootLvl" select="0"/>

		<xsl:variable name="vMnuLvl">
			<xsl:choose>
				<xsl:when test="($vDepth - $vRootLvl)&gt;2">
					<xsl:value-of select="2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="($vDepth - $vRootLvl)"/>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>

		<xsl:if test="$vUrl != 'outline.xml'">
			<xsl:choose>
				<xsl:when test="(@position = 'parent' or @position = 'ancestor' or @position = 'uncle')">
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="@position='current'">
							<xsl:if test="$vNbChild='0'">
								<li data-theme="d" data-mini="true" data-icon="false" class="ui-btn-active mnu_{$vMnuLvl}">
									<a href="#" class="menuItem" data-ajax="false">
										<img src="../skin/img/deco/{$vOutlineClasses}.png" class="ui-li-icon"/>
										<xsl:value-of select="@title" />
									</a>
								</li>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<li data-theme="d" data-mini="true" data-icon="{si($vNbChild &gt; 0,  'arrow-r', 'false')}" class="mnu_{$vMnuLvl}">
								<a href="{$vUrl}" class="{si($vNbChild &gt; 0,  'mnu-header', '')}" data-ajax="false">
									<xsl:if test="$vNbChild='0'">
										<img src="../skin/img/deco/{$vOutlineClasses}.png" class="ui-li-icon"/>
									</xsl:if>
									<xsl:value-of select="@title" />
								</a>
							</li>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="entry and descendant::entry and @position='current'">
				<li data-theme="d" data-mini="true" data-icon="arrow-d" class="ui-btn-active mnu_{$vMnuLvl}">
					<a href="#" data-ajax="false" onclick="return false;" class="mnu-header">
						<xsl:value-of select="@title" />
					</a>
				</li>
				<xsl:apply-templates>
					<xsl:with-param name="vRootLvl" select="$vRootLvl"/>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="entry and descendant::entry/@position='current'">
				<xsl:if test="not(@position = 'ancestor')">
					<li data-theme="d" data-mini="true" data-icon="arrow-l">
						<a href="{$vUrl}" data-ajax="false" class="mnu-header">
							<xsl:value-of select="@title" />
						</a>
					</li>
				</xsl:if>
				<xsl:apply-templates>
					<xsl:with-param name="vRootLvl" select="$vDepth"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="node()"/>
</xsl:stylesheet>