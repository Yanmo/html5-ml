<?xml version="1.0" encoding="UTF-8"?>
<!--
    ****************************************************************
    DITA to XSL-FO Stylesheet
    Module: Markup domain stylesheet
    Copyright © 2009-2016 Antenna House, Inc. All rights reserved.
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
        function:    markupname
        param:
        return:        fo:inline
        note:
    -->
    <xsl:template match="*[contains(@class, ' markup-d/markupname ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="4">
        <xsl:sequence select="'atsMarkupName'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' markup-d/markupname ')]" priority="4">
        <xsl:call-template name="processMarkupName"/>
    </xsl:template>

    <xsl:template name="processMarkupName">
        <span>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>
