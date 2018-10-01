<?xml version="1.0" encoding="UTF-8"?>
<!--
    ****************************************************************
    DITA to XSL-FO Stylesheet
    Module: MathML domain elements stylesheet
    Copyright © 2009-2014 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL    : http://www.antennahouse.com/
    E-mail : info@antennahouse.com
    ****************************************************************
-->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xs ahf"
>

    <!--
        function:    mathml template
        param:        none
        return:        fo:warapper
        note:        Only process child elements.
    -->
    <xsl:template match="*[contains(@class, ' mathml-d/mathml ')]" priority="2">
        <div>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--
        function:    m:math
        param:        none
        return:        object
        note:        none
    -->
    <xsl:template match="*[contains(@class, ' mathml-d/mathml ')]/m:math">
        <object>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:copy-of select="node()"/>
            </xsl:copy>
        </object>
    </xsl:template>

    <!--
        function:    mathml-d/mathmlref
        param:        none
        return:        img
        note:        none
    -->
    <xsl:template match="*[contains(@class, ' mathml-d/mathmlref ')]" priority="2">
        <img content-type="content-type:application/mathml+xml">
            <xsl:attribute name="src" select="ahf:getImageUrl(.)"/>
        </img>
    </xsl:template>

</xsl:stylesheet>
