<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Normalization stylesheet for Nissan SVG images.</xd:p>
            <xd:p><xd:b>Created on:</xd:b>April 24, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> Steven Shrader</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>

    <!-- For readability, set indent="yes" for testing. Change to no for production. -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="debug" select="'false'"/>

    <!-- Extract the boundaries of the viewBox -->
    <xsl:variable name="minx">
        <xsl:call-template name="extractviewboxcomponent">
            <xsl:with-param name="viewboxstring" select="svg:svg/@viewBox"/>
            <xsl:with-param name="componentindex" select="1"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="miny">
        <xsl:call-template name="extractviewboxcomponent">
            <xsl:with-param name="viewboxstring" select="svg:svg/@viewBox"/>
            <xsl:with-param name="componentindex" select="2"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="width">
        <xsl:call-template name="extractviewboxcomponent">
            <xsl:with-param name="viewboxstring" select="svg:svg/@viewBox"/>
            <xsl:with-param name="componentindex" select="3"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="height">
        <xsl:call-template name="extractviewboxcomponent">
            <xsl:with-param name="viewboxstring" select="svg:svg/@viewBox"/>
            <xsl:with-param name="componentindex" select="4"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- Store the style definitions in a variable so they can be parsed later -->
    <xsl:variable name="globalstylestring" select="svg:svg/svg:style"/>

    <xsl:variable name="nbsp">&#160;</xsl:variable>

    <!-- Don't copy the style element into the output file -->
    <xsl:template match="svg:style"/>

    <xsl:template match="svg:svg">
        <xsl:copy>
            <xsl:for-each select="attribute::*">
                <xsl:variable name="attrname" select="local-name(.)"/>
                <xsl:choose>
                    <!-- Exclude x, y, width, and height attributes -->
                    <xsl:when test="$attrname = 'x'"/>
                    <xsl:when test="$attrname = 'y'"/>
                    <xsl:when test="$attrname = 'width'"/>
                    <xsl:when test="$attrname = 'height'"/>
                    <xsl:otherwise>
                        <xsl:copy/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <!-- Add x, y, width, and height attributes, using values taken from viewBox -->
            <xsl:attribute name="x"><xsl:value-of select="$minx"/></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="$miny"/></xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
            <!-- For debugging, add a comment containing the style element contents. -->
            <xsl:if test="$debug = 'true'">
                <xsl:comment><xsl:text>style=</xsl:text><xsl:value-of select="$globalstylestring"/></xsl:comment>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="svg:g">
        <!-- Check if this group has a display attribute with the value "none" -->
        <xsl:variable name="displayattrnone" select="@display='none'"/>
        <!-- Store the value of the style attribute, if any -->
        <xsl:variable name="styleattrvalue">
            <xsl:if test="@style">
                <xsl:value-of select="@style"/>
            </xsl:if>
        </xsl:variable>
        <!-- Store the global style definitions referenced by the class attribute, if any -->
        <xsl:variable name="globalstylesfromclass">
            <xsl:if test="@class">
                <xsl:call-template name="processclasses">
                    <xsl:with-param name="classstr" select="@class"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <!-- Test if the style attribute contains "display:none" -->
        <xsl:variable name="styleattrnone">
            <xsl:call-template name="testdisplaynone">
                <xsl:with-param name="style">
                    <xsl:value-of select="$styleattrvalue"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!-- Test if the referenced global styles contain "display:none" -->
        <xsl:variable name="classstylenone">
            <xsl:call-template name="testdisplaynone">
                <xsl:with-param name="style">
                    <xsl:value-of select="$globalstylesfromclass"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!-- Copy this group and its children to the output ONLY IF it is set to be displayed -->
        <xsl:if test="$displayattrnone != true() and $styleattrnone != 'true' and $classstylenone != 'true'">
            <xsl:copy>
                <!-- Copy all attributes except for style and class -->
                <xsl:for-each select="attribute::*">
                    <xsl:variable name="attrname" select="local-name(.)"/>
                    <xsl:choose>
                        <xsl:when test="$attrname = 'style'"/>
                        <xsl:when test="$attrname = 'class'"/>
                        <xsl:otherwise>
                            <xsl:copy/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- Output a style attribute containing the contents of any previous style attribute, plus any global style definitions from the class attribute -->
                <xsl:if test="string-length($styleattrvalue) &gt; 0 or string-length($globalstylesfromclass) &gt; 0">
                    <xsl:attribute name="style">
                        <xsl:if test="string-length($styleattrvalue) &gt; 0">
                            <xsl:value-of select="$styleattrvalue"/>
                            <!-- The ends-with() function would really come in handy here, but is only available in XSLT 2.0 :-( -->
                            <xsl:if test="substring($styleattrvalue, string-length($styleattrvalue), 1) != ';'">
                                <!-- The style attribute contents did not end with a semicolon, so emit one here -->
                                <xsl:text>;</xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="string-length($globalstylesfromclass) &gt; 0">
                            <xsl:value-of select="$globalstylesfromclass"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
                <!-- Last, process the child elements of this element -->
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="svg:ellipse">
        <xsl:variable name="xradius" select="@rx"/>
        <xsl:variable name="yradius" select="@ry"/>
        <!-- Check if this ellipse is renderable; a negative or zero radius is invalid and makes the ellipse unrenderable -->
        <xsl:if test="$xradius &gt; 0 and $yradius &gt; 0">
            <xsl:copy>
                <xsl:variable name="styleattrvalue">
                    <xsl:if test="@style">
                        <xsl:value-of select="@style"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="globalstylesfromclass">
                    <xsl:if test="@class">
                        <xsl:call-template name="processclasses">
                            <xsl:with-param name="classstr" select="@class"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:for-each select="attribute::*">
                    <xsl:variable name="attrname" select="local-name(.)"/>
                    <xsl:choose>
                        <!-- ignore style and class attributes -->
                        <xsl:when test="$attrname = 'style'"/>
                        <xsl:when test="$attrname = 'class'"/>
                        <xsl:otherwise>
                            <xsl:copy/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- Output a style attribute containing the contents of any previous style attribute, plus any global style definitions from the class attribute -->
                <xsl:if test="string-length($styleattrvalue) &gt; 0 or string-length($globalstylesfromclass) &gt; 0">
                    <xsl:attribute name="style">
                        <xsl:if test="string-length($styleattrvalue) &gt; 0">
                            <xsl:value-of select="$styleattrvalue"/>
                            <!-- The ends-with() function would really come in handy here, but is only available in XSLT 2.0 :-( -->
                            <xsl:if test="substring($styleattrvalue, string-length($styleattrvalue), 1) != ';'">
                                <!-- The style attribute contents did not end with a semicolon, so emit one here -->
                                <xsl:text>;</xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="string-length($globalstylesfromclass) &gt; 0">
                            <xsl:value-of select="$globalstylesfromclass"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="svg:text">
        <xsl:copy>
            <!-- Save values of x, y, and transform attributes, if any -->
            <xsl:variable name="xattr">
                <xsl:if test="@x"><xsl:value-of select="@x"/></xsl:if>
            </xsl:variable>
            <xsl:variable name="yattr">
                <xsl:if test="@y"><xsl:value-of select="@y"/></xsl:if>
            </xsl:variable>
            <xsl:variable name="transformattr">
                <xsl:if test="@transform"><xsl:value-of select="@transform"/></xsl:if>
            </xsl:variable>
            <!-- Extract the original style string, if any -->
            <xsl:variable name="styleattrvalue">
                <xsl:if test="@style">
                    <xsl:value-of select="@style"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="globalstylesfromclass">
                <xsl:if test="@class">
                    <xsl:call-template name="processclasses">
                        <xsl:with-param name="classstr" select="@class"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <!-- Generate the output style string -->
            <xsl:variable name="originalstylestring">
                <xsl:if test="string-length($styleattrvalue) &gt; 0">
                    <xsl:value-of select="$styleattrvalue"/>
                    <!-- The ends-with() function would really come in handy here, but is only available in XSLT 2.0 :-( -->
                    <xsl:if test="substring($styleattrvalue, string-length($styleattrvalue), 1) != ';'">
                        <!-- The style attribute contents did not end with a semicolon, so emit one here -->
                        <xsl:text>;</xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="string-length($globalstylesfromclass) &gt; 0">
                    <xsl:value-of select="$globalstylesfromclass"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="originalfontname">
                <xsl:call-template name="extractpropertyfromstyle">
                    <xsl:with-param name="stylestring" select="$originalstylestring"/>
                    <xsl:with-param name="propertyname" select="'font-family'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="replacementfontname">
                <xsl:call-template name="substitutefont">
                    <xsl:with-param name="fontfamily" select="$originalfontname"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="strokevaluefromstyle">
                <xsl:call-template name="extractpropertyfromstyle">
                    <xsl:with-param name="stylestring" select="$originalstylestring"/>
                    <xsl:with-param name="propertyname" select="'stroke'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="replacementfillvalue">
                <xsl:choose>
                    <xsl:when test="string-length($strokevaluefromstyle) &gt; 0">
                        <xsl:value-of select="$strokevaluefromstyle"/>
                    </xsl:when>
                    <xsl:otherwise>#000000</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="editedstylestring">
                <xsl:call-template name="edittextstyle">
                    <xsl:with-param name="stylestring" select="$originalstylestring"/>
                    <xsl:with-param name="fontname" select="$replacementfontname"/>
                    <xsl:with-param name="fillvalue" select="$replacementfillvalue"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- Copy all attributes except those ignored below -->
            <xsl:for-each select="attribute::*">
                <xsl:variable name="attrname" select="local-name(.)"/>
                <xsl:choose>
                    <!-- Ignore these attributes, since they will be recreated below -->
                    <xsl:when test="$attrname = 'style'"/>
                    <xsl:when test="$attrname = 'class'"/>
                    <xsl:when test="$attrname = 'id'"/>
                    <xsl:when test="$attrname = 'x'"/>
                    <xsl:when test="$attrname = 'y'"/>
                    <xsl:when test="$attrname = 'transform'"/>
                    <xsl:otherwise>
                        <xsl:copy/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:if test="string-length($editedstylestring) &gt; 0">
                <!-- Create a style attribute with the edited style string -->
                <xsl:attribute name="style">
                    <xsl:value-of select="$editedstylestring"/>
                </xsl:attribute>
            </xsl:if>
            <!-- If a transform attribute was present, recreate it along with x and y attributes if present. -->
            <xsl:choose>
                <xsl:when test="string-length($transformattr) &gt; 0">
                    <xsl:attribute name="transform"><xsl:value-of select="$transformattr"/></xsl:attribute>
                    <xsl:if test="string-length($xattr) &gt; 0">
                        <xsl:attribute name="x"><xsl:value-of select="$xattr"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="string-length($yattr) &gt; 0">
                        <xsl:attribute name="y"><xsl:value-of select="$yattr"/></xsl:attribute>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <!-- If both x and y attributes were present, convert them to a transform attribute instead. Otherwise, add x and/or y attributes with their original values. -->
                    <xsl:choose>
                        <xsl:when test="string-length($xattr) &gt; 0 and string-length($yattr) &gt; 0">
                            <xsl:attribute name="transform"><xsl:value-of select="concat('matrix(1 0 0 1 ', $xattr, ' ', $yattr, ')')"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="string-length($xattr) &gt; 0">
                                <xsl:attribute name="x"><xsl:value-of select="$xattr"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="string-length($yattr) &gt; 0">
                                <xsl:attribute name="y"><xsl:value-of select="$yattr"/></xsl:attribute>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Create an id attribute with a value that can be sorted sequentially. This is required for callout extraction. -->
            <xsl:attribute name="id">
                <xsl:variable name="seqnum" select="concat('_', format-number(count(preceding::svg:text) + 1, '000000'))"/>
                <xsl:value-of select="$seqnum"/>
            </xsl:attribute>
            <!-- Last, process the child elements and nodes (including text nodes) of this element -->
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="svg:line">
        <xsl:variable name="x1attr" select="@x1"/>
        <xsl:variable name="y1attr" select="@y1"/>
        <xsl:variable name="x2attr" select="@x2"/>
        <xsl:variable name="y2attr" select="@y2"/>
        <!-- Only copy this line to the output if both endpoints are within the viewbox -->
        <!-- Note: In the sample images, there is at least one image (R253012R.svg) with a horizontal line that divides the image into sub-regions, but the endpoints of this line
             extend outside of the viewbox. We should avoid removing lines like this if possible. As all of the extraneous lines that extend from the "metadata" tables into the
             viewbox are vertical lines, it should be sufficient to only check the Y coordinates to determine which lines to remove. -->
        <!-- <xsl:if test="$x1attr &gt;= $minx and $x1attr &lt;= $width and $y1attr &gt;= $miny and $y1attr &lt;= $height and $x2attr &gt;= $minx and $x2attr &lt;= $width and $y2attr &gt;= $miny and $y2attr &lt;= $height"> -->
        <!-- Image R253015S.svg also has lines that divide the image into sub-regions, but they extend above the viewport and got removed by the initial version of this stylesheet, so this version will only test for Y coordinates below the viewport. -->
        <!-- <xsl:if test="$y1attr &gt;= $miny and $y1attr &lt;= $height and $y2attr &gt;= $miny and $y2attr &lt;= $height"> -->
        <xsl:if test="$y1attr &lt;= $height and $y2attr &lt;= $height">
            <xsl:copy>
                <xsl:variable name="styleattrvalue">
                    <xsl:if test="@style">
                        <xsl:value-of select="@style"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="globalstylesfromclass">
                    <xsl:if test="@class">
                        <xsl:call-template name="processclasses">
                            <xsl:with-param name="classstr" select="@class"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:for-each select="attribute::*">
                    <xsl:variable name="attrname" select="local-name(.)"/>
                    <xsl:choose>
                        <!-- ignore style and class attributes -->
                        <xsl:when test="$attrname = 'style'"/>
                        <xsl:when test="$attrname = 'class'"/>
                        <xsl:otherwise>
                            <xsl:copy/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- Output a style attribute containing the contents of any previous style attribute, plus any global style definitions from the class attribute -->
                <xsl:if test="string-length($styleattrvalue) &gt; 0 or string-length($globalstylesfromclass) &gt; 0">
                    <xsl:attribute name="style">
                        <xsl:if test="string-length($styleattrvalue) &gt; 0">
                            <xsl:value-of select="$styleattrvalue"/>
                            <!-- The ends-with() function would really come in handy here, but is only available in XSLT 2.0 :-( -->
                            <xsl:if test="substring($styleattrvalue, string-length($styleattrvalue), 1) != ';'">
                                <!-- The style attribute contents did not end with a semicolon, so emit one here -->
                                <xsl:text>;</xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="string-length($globalstylesfromclass) &gt; 0">
                            <xsl:value-of select="$globalstylesfromclass"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!-- For all remaining elements, copy the element then process the attributes. -->
    <!-- If a class attribute is found, extract the matching global style strings and put them into a style attribute.-->
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:variable name="styleattrvalue">
                <xsl:if test="@style">
                    <xsl:value-of select="@style"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="globalstylesfromclass">
                <xsl:if test="@class">
                    <xsl:call-template name="processclasses">
                        <xsl:with-param name="classstr" select="@class"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <xsl:for-each select="attribute::*">
                <xsl:variable name="attrname" select="local-name(.)"/>
                <xsl:choose>
                    <!-- ignore style and class attributes -->
                    <xsl:when test="$attrname = 'style'"/>
                    <xsl:when test="$attrname = 'class'"/>
                    <xsl:otherwise>
                        <xsl:copy/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <!-- Output a style attribute containing the contents of any previous style attribute, plus any global style definitions from the class attribute -->
            <xsl:if test="string-length($styleattrvalue) &gt; 0 or string-length($globalstylesfromclass) &gt; 0">
                <xsl:attribute name="style">
                    <xsl:if test="string-length($styleattrvalue) &gt; 0">
                        <xsl:value-of select="$styleattrvalue"/>
                        <!-- The ends-with() function would really come in handy here, but is only available in XSLT 2.0 :-( -->
                        <xsl:if test="substring($styleattrvalue, string-length($styleattrvalue), 1) != ';'">
                            <!-- The style attribute contents did not end with a semicolon, so emit one here -->
                            <xsl:text>;</xsl:text>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="string-length($globalstylesfromclass) &gt; 0">
                        <xsl:value-of select="$globalstylesfromclass"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <!-- Last, process the child elements of this element -->
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="processclasses">
        <xsl:param name="classstr"/>
        <xsl:if test="string-length($classstr) &gt; 0">
            <xsl:choose>
                <xsl:when test="contains($classstr, ' ')">
                    <xsl:variable name="thisclass" select="substring-before($classstr, ' ')"/>
                    <xsl:variable name="remainingclasses" select="substring-after($classstr, ' ')"/>
                    <!-- Look up the global style definition for this style name -->
                    <xsl:call-template name="lookupglobalstyle">
                        <xsl:with-param name="stylekey" select="$thisclass"/>
                    </xsl:call-template>
                    <!-- Call this template recursively with the remaining styles -->
                    <xsl:call-template name="processclasses">
                        <xsl:with-param name="classstr" select="$remainingclasses"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="lookupglobalstyle">
                        <xsl:with-param name="stylekey" select="$classstr"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="lookupglobalstyle">
        <xsl:param name="stylekey"/>
        <xsl:if test="contains($globalstylestring, concat('.', $stylekey))">
            <!-- Extract the text between the curly brackets immediately after the style name -->
            <xsl:variable name="stylevalue" select="normalize-space(substring-before(substring-after(normalize-space(substring-after($globalstylestring, concat('.', $stylekey))), '{'), '}'))"/>
            <xsl:value-of select="$stylevalue"/>
            <!-- The ends-with() function would really come in handy here, but is only available in XSLT 2.0 :-( -->
            <xsl:if test="substring($stylevalue, string-length($stylevalue), 1) != ';'">
                <!-- The style value does not end with a semicolon, so emit one here -->
                <xsl:text>;</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="extractviewboxcomponent">
        <xsl:param name="recursionlevel" select="1"/>
        <xsl:param name="viewboxstring"/>
        <xsl:param name="componentindex"/>
        <xsl:variable name="normalizedviewbox" select="normalize-space(translate($viewboxstring, concat($nbsp, ','), '  '))"/>
        <xsl:variable name="firstpart">
            <xsl:choose>
                <xsl:when test="contains($normalizedviewbox, ' ')">
                    <xsl:value-of select="substring-before($normalizedviewbox, ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$normalizedviewbox"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$componentindex = $recursionlevel">
                <xsl:value-of select="$firstpart"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="remainingparts">
                    <xsl:if test="contains($normalizedviewbox, ' ')">
                        <xsl:value-of select="substring-after($normalizedviewbox, ' ')"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="string-length($remainingparts) &gt; 0">
                    <xsl:call-template name="extractviewboxcomponent">
                        <xsl:with-param name="recursionlevel" select="$recursionlevel + 1"/>
                        <xsl:with-param name="viewboxstring" select="$remainingparts"/>
                        <xsl:with-param name="componentindex" select="$componentindex"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="testdisplaynone">
        <!-- test a style string to see if it contains a display attribute with a value of 'none' -->
        <xsl:param name="style"/>
        <xsl:if test="string-length($style &gt; 0)">
            <xsl:variable name="keyval">
                <xsl:choose>
                    <xsl:when test="contains($style, ';')">
                        <xsl:value-of select="normalize-space(substring-before($style, ';'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space($style)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="key" select="normalize-space(substring-before($keyval, ':'))"/>
            <xsl:variable name="value" select="normalize-space(substring-after($keyval, ':'))"/>
            <xsl:choose>
                <xsl:when test="$key = 'display'">
                    <xsl:if test="$value = 'none'">true</xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="remainder">
                        <xsl:if test="contains($style, ';')">
                            <xsl:value-of select="normalize-space(substring-after($style, ';'))"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:if test="string-length($remainder) &gt; 0">
                        <xsl:call-template name="testdisplaynone">
                            <xsl:with-param name="style" select="$remainder"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="extractpropertyfromstyle">
        <xsl:param name="stylestring"/>
        <xsl:param name="propertyname"/>
        <xsl:if test="string-length($stylestring) &gt; 0 and string-length($propertyname) &gt; 0">
            <xsl:variable name="keyval" select="normalize-space(substring-before($stylestring, ';'))"/>
            <xsl:variable name="key" select="normalize-space(substring-before($keyval, ':'))"/>
            <xsl:variable name="value" select="normalize-space(substring-after($keyval, ':'))"/>
            <xsl:choose>
                <xsl:when test="$key = $propertyname">
                    <xsl:value-of select="$value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="remainder" select="normalize-space(substring-after($stylestring, ';'))"/>
                    <xsl:if test="string-length($remainder) &gt; 0">
                        <xsl:call-template name="extractpropertyfromstyle">
                            <xsl:with-param name="stylestring" select="$remainder"/>
                            <xsl:with-param name="propertyname" select="$propertyname"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="substitutefont">
        <xsl:param name="fontfamily"/>
        <!-- Strip apostrophes from the input font name -->
        <xsl:variable name="apostrophe">&apos;</xsl:variable>
        <xsl:variable name="fontnamestripped" select="translate($fontfamily, $apostrophe, '')"/>
        <xsl:choose>
            <xsl:when test="$fontnamestripped = 'KozGoPr6N-Regular-90ms-RKSJ-H'">&apos;Noto Sans CJK JP Black&apos;</xsl:when>
            <xsl:when test="$fontnamestripped = 'Arial'">&apos;Noto Sans CJK JP&apos;</xsl:when>
            <xsl:when test="$fontnamestripped = 'MS-PGothic'">&apos;Noto Sans CJK JP&apos;</xsl:when>
            <xsl:when test="$fontnamestripped = 'Txt'">&apos;Noto Sans CJK JP&apos;</xsl:when>
            <xsl:when test="$fontnamestripped = 'Monotxt'">&apos;Noto Sans Mono CJK JP&apos;</xsl:when>
            <xsl:when test="$fontnamestripped = 'MS Gothic'">&apos;Noto Sans Mono CJK JP&apos;</xsl:when>
            <xsl:otherwise>&apos;Noto Sans CJK JP&apos;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="edittextstyle">
        <xsl:param name="stylestring"/>
        <xsl:param name="fontname"/>
        <xsl:param name="fillvalue"/>
        <xsl:variable name="keyval" select="normalize-space(substring-before($stylestring, ';'))"/>
        <xsl:variable name="key" select="normalize-space(substring-before($keyval, ':'))"/>
        <xsl:variable name="value" select="normalize-space(substring-after($keyval, ':'))"/>
        <xsl:choose>
            <xsl:when test="$key = 'font-family'">
                <xsl:text>font-family:</xsl:text>
                <xsl:value-of select="$fontname"/>
                <xsl:text>;</xsl:text>
            </xsl:when>
            <xsl:when test="$key = 'fill'">
                <xsl:text>fill:</xsl:text>
                <xsl:value-of select="$fillvalue"/>
                <xsl:text>;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$key"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="$value"/>
                <xsl:text>;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="remainder" select="normalize-space(substring-after($stylestring, ';'))"/>
        <xsl:if test="string-length($remainder) &gt; 0">
            <xsl:call-template name="edittextstyle">
                <xsl:with-param name="stylestring" select="$remainder"/>
                <xsl:with-param name="fontname" select="$fontname"/>
                <xsl:with-param name="fillvalue" select="$fillvalue"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>