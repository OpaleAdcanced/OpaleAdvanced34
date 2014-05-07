<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:java="http://xml.apache.org/xslt/java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="java" version="1.0">
	<xsl:output encoding="UTF-8" indent="no" method="xml"/>
	<xsl:param name="vDialog"/>
	<xsl:param name="vAgent"/>
	<xsl:template match="*">
		<html xml:lang="￼fr￼">
			<head>
				<xsl:variable name="vWinTitle">
					<xsl:value-of select="intituleAgent($vDialog)"/>
				</xsl:variable>
				<title>
					<xsl:value-of select="normalize-space($vWinTitle)"/>
				</title>
				<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=UTF-8"/>
				<meta http-equiv="Content-Style-Type" content="text/css"/>
				<link rel="stylesheet" type="text/css" href="{resultatAgent('//', 'pubres:/site/skin/skin.css')}"/>
			</head>
			<body>
				<xsl:value-of disable-output-escaping="yes" select="resultatAgent($vDialog, 'zone:mainZone')"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>