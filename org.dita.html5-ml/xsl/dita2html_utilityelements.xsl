<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Utility elements stylesheet
Copyright © 2009-2009 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf"
>

    <!--
         Almost of DITA utility elements are for HTML output.
         XSL 1.1 cannot support these functions.
     -->

    <!--
     function:    imagemap template
     param:
     return:    fo:block
     note:        none
     -->
    <xsl:template match="*[contains(@class, ' ut-d/imagemap ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="2">
        <xsl:sequence select="'atsImageMap'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' ut-d/imagemap ')]" priority="2">
        <xsl:variable name="imageMapAttr" as="attribute()*">
            <xsl:call-template name="getAttributeSetWithLang"/>
        </xsl:variable>
        <div>
            <xsl:copy-of select="$imageMapAttr"/>
            <xsl:copy-of select="ahf:getDisplayAtts(.,$imageMapAttr)"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--
     function:    area template
     param:
     return:    div
     note:        none
     -->

    <xsl:template match="*[contains(@class,' ut-d/area ')]" priority="2">
        <div>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--
     function:    shape template
     param:
     return:    div
     note:        none
     -->
    <xsl:template match="*[contains(@class,' ut-d/shape ')]" priority="2">
        <div>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <!-- ignore contents -->
        </div>
    </xsl:template>

    <!--
     function:    coords template
     param:
     return:    div
     note:        none
     -->
    <xsl:template match="*[contains(@class,' ut-d/coords ')]" priority="2">
        <div>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <!-- ignore contents -->
        </div>
    </xsl:template>

    <!--
     function:    area/xref template
     param:
     return:    div
     note:        none
     -->
    <xsl:template match="*[contains(@class,' ut-d/area ')]/*[contains(@class,' topic/xref ')]" priority="2">
        <div>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <!-- ignore xref -->
        </div>
    </xsl:template>

    <!--
     function:    sortas template
     param:
     return:    none
     note:        none
     -->
    <xsl:template match="*[contains(@class,' ut-d/sort-as ')]" priority="2">
    </xsl:template>


</xsl:stylesheet>
