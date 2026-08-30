<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:imageData="http://sbs.snapon.com/imageData"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Callout extraction stylesheet for Nissan SVG images.</xd:p>
            <xd:p><xd:b>Created on:</xd:b> May 4, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> Steven Shrader</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <!-- For readability, set indent="yes" for testing. Change to no for production. -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

    <!-- Callout extraction stylesheets must accept these two parameters -->
    <xsl:param name="imageName"/>
    <xsl:param name="imageType" select="string('PNG')"/>

    <!-- Global configuration variables -->
    <xsl:variable name="calloutType" select="string('bounds')"/><!-- If set to 'point' then point callouts will be created, otherwise bounds callouts will be created -->
    <xsl:variable name="calloutMargin" select="0.2"/><!-- Percentage of callout height to add as a margin -->
    <xsl:variable name="Qfactor" select="0.8"/><!-- Compensate for the increased height of a callout if it contains a "Q" -->

    <!-- Set global variables for the image width and height, as these values will be needed in multiple templates -->
    <xsl:variable name="imageWidth"><xsl:value-of select="/annotations/@width"/></xsl:variable>
    <xsl:variable name="imageHeight"><xsl:value-of select="/annotations/@height"/></xsl:variable>

    <!-- Start at the root -->
    <xsl:template match="/">
        <xsl:variable name="fixedImageName">
            <xsl:choose>
                <xsl:when test="contains($imageName, '.')"><xsl:value-of select="substring-before($imageName, '.')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$imageName"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="imageData" namespace="http://sbs.snapon.com/imageData">
            <xsl:attribute name="version">2.0</xsl:attribute>
            <xsl:attribute name="imageName"><xsl:value-of select="$fixedImageName"/></xsl:attribute>
            <xsl:attribute name="imageType"><xsl:value-of select="$imageType"/></xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="$imageWidth"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="$imageHeight"/></xsl:attribute>
            <xsl:apply-templates/>
            <xsl:element name="calloutStyles" namespace="http://sbs.snapon.com/imageData">
                <xsl:element name="calloutStyle" namespace="http://sbs.snapon.com/imageData">
                    <xsl:attribute name="name">NONE</xsl:attribute>
                    <xsl:attribute name="state">noState</xsl:attribute>
                    <xsl:attribute name="style">fill:#000000;fill-opacity:0.0;stroke:#000000;stroke-opacity:0.0;stroke-width:0;</xsl:attribute>
                    <xsl:element name="pattern"  namespace="http://sbs.snapon.com/imageData"/>
                </xsl:element>
                <xsl:element name="calloutStyle" namespace="http://sbs.snapon.com/imageData">
                    <xsl:attribute name="name">SEL</xsl:attribute>
                    <xsl:attribute name="state">selected</xsl:attribute>
                    <xsl:attribute name="style">fill:#00FF00;fill-opacity:0.4;stroke:#00FF00;stroke-opacity:0.0;stroke-width:0;</xsl:attribute>
                    <xsl:element name="pattern"  namespace="http://sbs.snapon.com/imageData"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="annotations">
        <xsl:element name="callouts" namespace="http://sbs.snapon.com/imageData">
            <xsl:attribute name="shape">rectangle</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="annotation">
        <xsl:variable name="label" select="normalize-space(@text)"/>
        <xsl:variable name="x" select="string(@x)"/>
        <xsl:variable name="y" select="string(@y)"/>
        <xsl:variable name="w" select="string(@w)"/>
        <xsl:variable name="h" select="string(@h)"/>
        <!-- Check coordinates to see if within image boundary -->
        <xsl:if test="$x &gt;= 0 and $x &lt; $imageWidth and $y &gt;= 0 and $y &lt; $imageHeight">
            <!-- Check to see if label matches one of the callout patterns. -->
            <xsl:variable name="isCallout">
                <xsl:call-template name="testCallout">
                    <xsl:with-param name="labelString" select="$label"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$isCallout = 'true'">
                <xsl:element name="callout" namespace="http://sbs.snapon.com/imageData">
                    <xsl:attribute name="label"><xsl:value-of select="$label"/></xsl:attribute>
                    <xsl:variable name="heightScale">
                        <!-- In the "Noto Sans CJK JP" font, only the Q has a descender -->
                        <xsl:choose>
                            <xsl:when test="contains($label, 'Q')"><xsl:value-of select="$Qfactor"/></xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="scaledH" select="$h * $heightScale"/>
                    <xsl:choose>
                        <xsl:when test="$calloutType = 'point'">
                            <xsl:variable name="px" select="$x + floor($w div 2)"/>
                            <xsl:variable name="py" select="$y + floor($scaledH div 2)"/>
                            <xsl:element name="point" namespace="http://sbs.snapon.com/imageData">
                                <xsl:attribute name="x"><xsl:value-of select="$px"/></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$py"/></xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Add margin. Note: Callout width will vary depending on the number of characters,
                                 so margin will be a percentage of the height. Also clip the callout if it would 
                                 extend beyond the edge of the image after the margin is added. -->
                            <xsl:variable name="rawXValue" select="floor($x - ($scaledH * $calloutMargin))"/>
                            <xsl:variable name="adjustedX">
                                <xsl:choose>
                                    <xsl:when test="$rawXValue &lt; 0">0</xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$rawXValue"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="rawYValue" select="floor($y - ($scaledH * $calloutMargin))"/>
                            <xsl:variable name="adjustedY">
                                <xsl:choose>
                                    <xsl:when test="$rawYValue &lt; 0">0</xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$rawYValue"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="rawWValue" select="ceiling($w + ($scaledH * $calloutMargin * 2))"/>
                            <xsl:variable name="adjustedW">
                                <xsl:variable name="slack" select="$imageWidth - ($rawXValue + $rawWValue)"/>
                                <xsl:choose>
                                    <xsl:when test="$slack &gt;= 0">
                                        <xsl:choose>
                                            <xsl:when test="$rawXValue &gt; 0"><xsl:value-of select="$rawWValue"/></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="$rawWValue + $rawXValue"/></xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$rawWValue + $slack"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="rawHValue" select="ceiling($scaledH + ($scaledH * $calloutMargin * 2))"/>
                            <xsl:variable name="adjustedH">
                                <xsl:variable name="slack" select="$imageHeight - ($rawYValue + $rawHValue)"/>
                                <xsl:choose>
                                    <xsl:when test="$slack &gt;= 0">
                                        <xsl:choose>
                                            <xsl:when test="$rawYValue &gt; 0"><xsl:value-of select="$rawHValue"/></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="$rawHValue + $rawYValue"/></xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$rawHValue + $slack"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:element name="bounds" namespace="http://sbs.snapon.com/imageData">
                                <xsl:attribute name="x"><xsl:value-of select="$adjustedX"/></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$adjustedY"/></xsl:attribute>
                                <xsl:attribute name="w"><xsl:value-of select="$adjustedW"/></xsl:attribute>
                                <xsl:attribute name="h"><xsl:value-of select="$adjustedH"/></xsl:attribute>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="testCallout">
        <xsl:param name="labelString"/>
        <xsl:variable name="labelStringAlnum" select="translate($labelString, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 'AAAAAAAAAAAAAAAAAAAAAAAAAANNNNNNNNNN')"/>
        <!-- Analysis of callout label strings from catalog text shows that they all match one of these patterns of alphanumeric characters -->
        <xsl:choose>
            <xsl:when test="$labelStringAlnum = 'AANNN'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'AANNNN'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'ANNNN'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'ANNNNA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'ANNNNNA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNAN'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNAN+A'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNANA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNANAA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNAA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNAAA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNN'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNN+A'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNNA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNNAA'">true</xsl:when>
            <xsl:when test="$labelStringAlnum = 'NNNNNN'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>