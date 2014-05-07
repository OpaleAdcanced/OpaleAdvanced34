<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="sc sp date dateFormat locale op mobile java" version="1.0" xmlns:date="http://xml.apache.org/xalan/java/java.util.Date" xmlns:dateFormat="http://xml.apache.org/xalan/java/java.text.SimpleDateFormat" xmlns:java="http://xml.apache.org/xalan/java" xmlns:locale="http://xml.apache.org/xalan/java/java.util.Locale" xmlns:mobile="http://scenari.soreha.fr/sc-mobile" xmlns:op="utc.fr:ics/opale3" xmlns:sc="http://www.utc.fr/ics/scenari/v3/core" xmlns:sp="http://www.utc.fr/ics/scenari/v3/primitive" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="vArguments"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="op:rssScReader">
		<rss version="2.0">
			<channel>
				<xsl:apply-templates/>
			</channel>
		</rss>
	</xsl:template>
	<xsl:template match="op:rssScReaderM">
		<xsl:apply-templates/>
		<pubDate>
			<xsl:call-template name="tFormatDateRfc822">
				<xsl:with-param name="pDate" select="sp:pubDate"/>
			</xsl:call-template>
		</pubDate>
	</xsl:template>
	<xsl:template match="sp:title | sp:link | sp:description | sp:language | sp:managingEditor | sp:webMaster | sp:copyright ">
		<xsl:element name="{local-name(.)}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="sp:item">
		<item>
			<title>
				<xsl:choose>
					<xsl:when test="op:rssItemM/sp:title">
						<xsl:value-of select="op:rssItemM/sp:title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="getContent(gotoSubModel(), 'title')"/>
					</xsl:otherwise>
				</xsl:choose>
			</title>
			<xsl:variable name="vPubDate">
				<xsl:call-template name="tFormatDateRfc822">
					<xsl:with-param name="pDate" select="op:rssItemM/sp:pubDate"/>
				</xsl:call-template>
			</xsl:variable>
			<pubDate>
				<xsl:value-of select="$vPubDate"/>
			</pubDate>
			<xsl:variable name="vGenUrl">
				<xsl:value-of select="../op:rssScReaderM/sp:base"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="getUrl(gotoSubModel())"/>
			</xsl:variable>
			<xsl:variable name="vIsOnline" select="../op:rssScReaderM/sp:onlineDisponibility"/>
			<xsl:variable name="vUrlLink">
				<xsl:choose>
					<xsl:when test="$vIsOnline='yes'">
						<xsl:value-of select="$vGenUrl"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(substring-before($vGenUrl,'index.html'), 'phone.zip')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="vUrl" select="concat(substring-before($vGenUrl,'index.html'), 'phone.zip')"/>
			<guid>
				<xsl:value-of select="$vUrl"/>
			</guid>
			<link>
				<xsl:value-of select="$vUrlLink"/>
			</link>
			<xsl:variable name="vSmallImagette">
				<xsl:if test="op:rssItemM/sp:imagetteSmall">
					<xsl:value-of select="concat(../op:rssScReaderM/sp:base, '/', parseXml(getContent(gotoSubModel(op:rssItemM/sp:imagetteSmall), 'small'))/img/@src)"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="vLargeImagette">
				<xsl:if test="op:rssItemM/sp:imagetteLarge">
					<xsl:value-of select="concat(../op:rssScReaderM/sp:base, '/', parseXml(getContent(gotoSubModel(op:rssItemM/sp:imagetteLarge), 'large'))/img/@src)"/>
				</xsl:if>
			</xsl:variable>
			<xsl:apply-templates select="op:rssItemM/sp:category"/>
			<xsl:value-of disable-output-escaping="yes" select="resultatAgent(concat('@', gotoSubModel(), '_ArssCo/xhtmlContent'),     concat('url=', $vUrl,';baseUrl=', ../op:rssScReaderM/sp:base,';pubDate=', $vPubDate, ';smallImagette=', $vSmallImagette,';largeImagette=', $vLargeImagette,';'))"/>
		</item>
	</xsl:template>
	<xsl:template match="sp:complement"/>
	<xsl:template match="sp:category">
		<category>
			<xsl:value-of select="."/>
		</category>
	</xsl:template>
	<xsl:template match="sp:image">
		<xsl:variable name="vUrl" select="concat(../sp:base, '/', parseXml(getContent(gotoSubModel(), 'large'))/img/@src)"/>
		<xsl:variable name="vFullTitle" select="getFullTitleText(gotoSubModel())"/>
		<image>
			<title>
				<xsl:choose>
					<xsl:when test="$vFullTitle">
						<xsl:value-of select="$vFullTitle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../sp:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</title>
			<xsl:apply-templates select="../sp:link"/>
			<url>
				<xsl:value-of select="$vUrl"/>
			</url>
		</image>
	</xsl:template>
	<xsl:template match="sp:author"/>
	<!-- Utilitaires ================================================================ -->
	<xsl:template name="tFormatDateRfc822">
		<xsl:param name="pDate"/>
		<xsl:call-template name="tFormatDate">
			<xsl:with-param name="pDate" select="$pDate"/>
			<xsl:with-param name="pFormat">EEE, d MMM yyyy HH:mm:ss Z</xsl:with-param>
			<xsl:with-param name="pLanguage">en</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- Transforme une date en un format quelconque -->
	<xsl:template name="tFormatDate">
		<xsl:param name="pDate"/>
		<xsl:param name="pFormat"/>
		<xsl:param name="pLanguage"/>
		<xsl:variable name="vInFormatter" select="dateFormat:new('yyyy-MM-dd')"/>
		<xsl:variable name="vPos" select="dateFormat:new('yyyy-MM-dd')"/>
		<xsl:variable name="vOutFormatter" select="si($pFormat, si($pLanguage, dateFormat:new($pFormat, locale:new($pLanguage)), dateFormat:new($pFormat)), dateFormat:new())"/>
		<xsl:variable name="vPos" select="java:text.ParsePosition.new(0)"/>
		<xsl:variable name="vDate" select="si($pDate, dateFormat:parse($vInFormatter, $pDate, $vPos), date:new())"/>
		<xsl:value-of select="dateFormat:format($vOutFormatter, $vDate)"/>
	</xsl:template>
	<!-- Transforme un timestamp dans un format quelconque -->
	<xsl:template name="tFormatTime">
		<xsl:param name="pTime"/>
		<xsl:param name="pFormat"/>
		<xsl:param name="pLanguage"/>
		<xsl:variable name="vFormatter" select="si($pFormat, si($pLanguage, dateFormat:new($pFormat, locale:new($pLanguage)), dateFormat:new($pFormat)), dateFormat:new())"/>
		<xsl:variable name="vDate" select="date:new($pTime - 3600000)"/>
		<xsl:value-of select="dateFormat:format($vFormatter, $vDate)"/>
	</xsl:template>
	<!-- Transforme une duree en seconde vers le format hh:mm:ss -->
	<xsl:template name="tFormatDuration">
		<xsl:param name="pDuration"/>
		<xsl:variable name="vFormat" select="si($pDuration &gt;= 3600, 'HH:mm:ss', 'mm:ss')"/>
		<xsl:call-template name="tFormatTime">
			<xsl:with-param name="pTime" select="$pDuration * 1000"/>
			<xsl:with-param name="pFormat" select="$vFormat"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="* | text()"/>
</xsl:stylesheet>