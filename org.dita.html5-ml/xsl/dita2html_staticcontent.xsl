<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Static content stylesheet
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
     function:    frontmatter static content template
     param:        none
     return:    fo:block
     note:        current is topicref
     -->
    <xsl:template name="frontmatterBeforeLeft">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionBeforeLeftBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="frontmatterBeforeRight">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionBeforeRightBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="frontmatterAfterLeft">
        <!--fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfter_InlineContainer')"/>
            </span>
            <!-\- Book title -\->
            <xsl:copy-of select="$bookTitle"/>
        </fo:block-->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfter_InlineContainer')"/>
            </span>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
        </div>
    </xsl:template>

    <xsl:template name="frontmatterAfterRight">
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfterRightBlock')"/>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfter_InlineContainer')"/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
        </div>
    </xsl:template>

    <!--
     function:    part/chapter static content template
     param:        none
     return:    fo:block
     note:        current is topicref
     -->
    <xsl:template name="chapterBeforeLeft">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionBeforeLeftBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="chapterBeforeRight">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionBeforeRightBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="chapterAfterLeft">
        <!--fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfter_InlineContainer')"/>
            </span>
            <xsl:copy-of select="$bookTitle"/>
        </fo:block-->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfter_InlineContainer')"/>
            </span>
            <!-- Part/chapter title -->
            <xsl:if test="$pAddNumberingTitlePrefix">
                <fo:retrieve-marker retrieve-class-name="{$cTitlePrefix}"/>
                <xsl:text> </xsl:text>
            </xsl:if>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
        </div>
    </xsl:template>

    <xsl:template name="chapterAfterRight">
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfterRightBlock')"/>
            <!-- Part/chapter title -->
            <xsl:if test="$pAddNumberingTitlePrefix">
                <fo:retrieve-marker retrieve-class-name="{$cTitlePrefix}"/>
                <xsl:text> </xsl:text>
            </xsl:if>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfter_InlineContainer')"/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
        </div>
    </xsl:template>

    <!-- Current context is topicref
         2014-09-14 t.makita
     -->
    <xsl:template name="chapterEndRight">
        <xsl:if test="$pAddThumbnailIndex">
            <xsl:call-template name="genThumbIndex">
                <xsl:with-param name="prmId" select="ahf:generateId(.,())"/>
                <xsl:with-param name="prmClass">
                    <xsl:choose>
                        <xsl:when test="ancestor-or-self::*[contains(@class, ' bookmap/part ')]">
                            <xsl:value-of select="$cClassPart"/>
                        </xsl:when>
                        <xsl:when test="ancestor-or-self::*[contains(@class, ' bookmap/appendix ')]">
                            <xsl:value-of select="$cClassAppendix"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$cClassChapter"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Genrate thumbnail if this is online PDF.
         2014-09-14 t.makita
     -->
    <xsl:template name="chapterEndLeft">
        <xsl:if test="$pIsWebOutput and $pAddThumbnailIndex">
            <xsl:call-template name="chapterEndRight"/>
        </xsl:if>
    </xsl:template>

    <!--
     function:    index static content template
     param:        none
     return:    fo:block
     note:        Current context is booklists/indexlist
     -->
    <xsl:template name="indexBeforeLeft">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionBeforeLeftBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="indexBeforeRight">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionBeforeRightBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="indexAfterLeft">
        <!--fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfter_InlineContainer')"/>
            </span>
            <!-\- Book title -\->
            <xsl:copy-of select="$bookTitle"/>
        </fo:block-->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfter_InlineContainer')"/>
            </span>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
        </div>
    </xsl:template>

    <xsl:template name="indexAfterRight">
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfterRightBlock')"/>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfter_InlineContainer')"/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
        </div>
    </xsl:template>

    <xsl:template name="indexEndRight">
        <xsl:if test="$pAddThumbnailIndex">
            <xsl:call-template name="genThumbIndex">
                <xsl:with-param name="prmId" select="''"/>
                <xsl:with-param name="prmClass" select="$cClassIndex"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="indexEndLeft">
        <xsl:if test="$pIsWebOutput and $pAddThumbnailIndex">
            <xsl:call-template name="indexEndRight"/>
        </xsl:if>
    </xsl:template>

    <!--
     function:    backmatter static content template
     param:        none
     return:    fo:block
     note:        current is topicref
     -->
    <xsl:template name="backmatterBeforeLeft">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionBeforeLeftBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="backmatterBeforeRight">
        <!-- No contents, border only -->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionBeforeRightBlock')"/>
        </div>
    </xsl:template>

    <xsl:template name="backmatterAfterLeft">
        <!--fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfter_InlineContainer')"/>
            </span>
            <!-\- Book title -\->
            <xsl:copy-of select="$bookTitle"/>
        </fo:block-->
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfterLeftBlock')"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfter_InlineContainer')"/>
            </span>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
        </div>
    </xsl:template>

    <xsl:template name="backmatterAfterRight">
        <div>
            <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfterRightBlock')"/>
            <fo:retrieve-marker retrieve-class-name="{$cTitleBody}"/>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfter_InlineContainer')"/>
            </span>
            <span>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </span>
        </div>
    </xsl:template>

</xsl:stylesheet>
