<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Glossary list stylesheet
Copyright © 2011-2011 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 xmlns:psmi="http://www.CraneSoftwrights.com/resources/psmi"
 exclude-result-prefixes="xs ahf"
>

    <!-- IMPORTANT LIMITATION
         If the parameter PRM_SORT_GLOSSENTRY='yes', this stylesheet ignores following indexterm.
           glossgroup/prolog/metadata/keywords/indexterm
         This is because the target that indexterm point become ambigous when sorting glossgroup/glossentry.
     -->

    <!--
     function:    Generate glossary list template
     param:        none
     return:    (html)
     note:      1. Current context is booklist/glossarylist
                 2. This template made by the basis of the promise
                 that all of the topicrefs to the glossentry
                 are located under *THIS* topicref.
     -->
    <xsl:template name="genGlossaryList" >
        <psmi:page-sequence>
            <xsl:choose>
                <xsl:when test="ancestor::*[contains(@class,' bookmap/frontmatter ')]">
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqGlossaryList')"/>
                    <xsl:if test="not(preceding-sibling::*) and
                                  not(parent::*/preceding-sibling::*[contains(@class,' map/topicref ')])">
                        <xsl:attribute name="initial-page-number" select="'1'"/>
                    </xsl:if>
                    <body flow-name="xsl-region-body">
                        <xsl:call-template name="genGlossaryListMain"/>
                    </body>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqGlossaryList')"/>
                    <body flow-name="xsl-region-body">
                        <xsl:call-template name="genGlossaryListMain"/>
                    </body>
                </xsl:otherwise>
            </xsl:choose>
        </psmi:page-sequence>
    </xsl:template>

    <!--
     function:    Glossary list main template
     param:
     return:    fo:block
     note:        Current context is booklist/glossarylist
     -->
    <xsl:template name="genGlossaryListMain">
        <xsl:variable name="topicRef" select="."/>
        <!-- get topic from @href -->
        <xsl:variable name="id" select="substring-after(@href, '#')" as="xs:string"/>
        <xsl:variable name="topicContent" as="element()?" select="ahf:getTopicFromTopicRef($topicRef)"/>
        <xsl:variable name="titleMode" select="ahf:getTitleMode($topicRef,())" as="xs:integer"/>

        <xsl:choose>
            <xsl:when test="exists($topicContent)">
                <xsl:apply-templates select="$topicContent" mode="PROCESS_GLOSSARYLIST_PREFIX_CONTENT">
                    <xsl:with-param name="prmTopicRef"   tunnel="yes" select="$topicRef"/>
                    <xsl:with-param name="prmTitleMode"  select="$titleMode"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <xsl:copy-of select="ahf:getAttributeSet('atsBaseGlossaryListPrefixContent')"/>
                    <div>
                        <xsl:copy-of select="ahf:getAttributeSet('atsSpanAll')"/>
                        <xsl:copy-of select="ahf:getAttributeSet('atsFmHeader1')"/>
                        <xsl:copy-of select="ahf:getIdAtts($topicRef,$topicRef,true())"/>
                        <!--xsl:attribute name="id" select="$cGlossaryListId"/-->
                        <xsl:variable name="glossaryListTitleText" as="xs:string">
                            <xsl:choose>
                                <xsl:when test="$topicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                                    <xsl:variable name="titleTextTemp">
                                        <xsl:apply-templates select="$topicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]" mode="TEXT_ONLY"/>
                                    </xsl:variable>
                                    <xsl:sequence select="string-join($titleTextTemp,'')"/>
                                </xsl:when>
                                <xsl:when test="$topicRef/@navtitle">
                                    <xsl:sequence select="string($topicRef/@navtitle)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="$cGlossaryListTitle"></xsl:sequence>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <a marker-class-name="{$cTitleBody}">
                            <span><xsl:copy-of select="$glossaryListTitleText"/></span>
                        </a>
                        <xsl:choose>
                            <xsl:when test="$topicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                                <xsl:apply-templates select="$topicRef/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                                    <xsl:with-param name="prmTopicRef" tunnel="yes" select="$topicRef"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:when test="$topicRef/@navtitle">
                                <span>
                                    <xsl:value-of select="string($topicRef/@navtitle)"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span>
                                    <xsl:value-of select="$cGlossaryListTitle"/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Insert dummy blcok for span="all"/"normal" boundary -->
        <xsl:copy-of select="ahf:getFormattingObject('foColSpanDummyBlock')"/>

        <!-- Process child topicref -->
        <xsl:choose>
            <xsl:when test="$pSortGlossEntry">
                <!-- Original glossentry nodeset -->
                <xsl:variable name="glossEntries" as="document-node()">
                    <xsl:document>
                        <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="PROCESS_GLOSSARYLIST_TOPICREF_IN_TEMPORARY_TREE">
                        </xsl:apply-templates>
                    </xsl:document>
                </xsl:variable>
                <!-- Sorted glossentry nodeset -->
                <xsl:variable name="glossEntrySorted" as="document-node()">
                    <xsl:document>
                        <xsl:for-each select="$glossEntries/*[contains(@class, ' glossentry/glossentry ')]">
                            <xsl:sort lang="{$documentLang}" select="@sortkey"/>
                            <xsl:element name="{name()}">
                                <xsl:copy-of select="@*"/>
                                <xsl:attribute name="label" select="upper-case(substring(string(@sortkey),1,1))"/>
                                <xsl:copy-of select="child::node()"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:document>
                </xsl:variable>
                <!-- Format the sorted glossentry -->
                <xsl:for-each select="$glossEntrySorted/*[contains(@class,' glossentry/glossentry ')]">
                    <xsl:variable name="glossEntry" select="."/>
                    <xsl:variable name="topicRefId" select="string($glossEntry/@topicRefId)" as="xs:string"/>
                    <xsl:variable name="topicRef" select="$map//*[contains(@class, 'map/topicref')][ahf:generateId(.,()) eq $topicRefId][1]" as="element()*"/>
                    <xsl:choose>
                        <xsl:when test="exists($topicRef)">
                            <xsl:apply-templates select="$glossEntry" mode="PROCESS_GLOSSARYLIST_CONTENT">
                                <xsl:with-param name="prmTopicRef" tunnel="yes" select="$topicRef"/>
                                <xsl:with-param name="prmNeedId"   tunnel="yes" select="true()"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="errorExit">
                                <xsl:with-param name="prmMes"
                                    select="ahf:replace($stMes078,('%id','%file'),(string($topicRefId),string(@xtrf)))"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="PROCESS_GLOSSARYLIST_TOPICREF">
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>

        <!-- generate a class="index-range-end" for metadata -->
        <xsl:call-template name="processIndextermInMetadataEnd">
            <xsl:with-param name="prmTopicRef"     select="$topicRef"/>
            <xsl:with-param name="prmTopicContent" select="$topicContent"/>
        </xsl:call-template>
    </xsl:template>

    <!--
        function:    Process topic (glossarylist)
        param:        prmTopicRef
        return:        topic contents
        note:        Changed to output post-note per topic/body. 2011-07-28 t.makita
    -->
    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="PROCESS_GLOSSARYLIST_PREFIX_CONTENT">
        <xsl:param name="prmTopicRef" tunnel="yes"  required="yes" as="element()"/>

        <div>
            <xsl:call-template name="getAttributeSetWithLang">
                <xsl:with-param name="prmAttrSetName" select="'atsBaseGlossaryListPrefixContent'"/>
                <xsl:with-param name="prmDoInherit" select="true()"/>
            </xsl:call-template>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:call-template name="ahf:getLocalizationAtts"/>
            <xsl:copy-of select="ahf:getAttributeSet('atsSpanAll')"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>

            <!-- title -->
            <xsl:call-template name="genBackmatterTitle">
                <xsl:with-param name="prmLevel" select="1"/>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmTopicContent" select="."/>
            </xsl:call-template>

            <!-- abstract/shortdesc -->
            <xsl:apply-templates select="child::*[contains(@class, ' topic/abstract ')] | child::*[contains(@class, ' topic/shortdesc ')]"/>

            <!-- body -->
            <xsl:apply-templates select="child::*[contains(@class, ' topic/body ')]"/>

            <!-- postnote (footnote) -->
            <xsl:choose>
                <xsl:when test="$pDisplayFnAtEndOfTopic">
                    <xsl:call-template name="makePostNote">
                        <xsl:with-param name="prmTopicRef"     select="$prmTopicRef"/>
                        <xsl:with-param name="prmTopicContent" select="./*[contains(@class,' topic/body ')]"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="makeFootNote">
                        <xsl:with-param name="prmElement"  select="."/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>

            <!-- nested concept/reference/task -->
            <xsl:apply-templates select="child::*[contains(@class, ' topic/topic ')]" mode="#current">
                <xsl:with-param name="prmTopicRef" tunnel="yes" select="$prmTopicRef"/>
            </xsl:apply-templates>

            <!-- related-links -->
            <xsl:apply-templates select="child::*[contains(@class,' topic/related-links ')]"/>

        </div>
    </xsl:template>

    <!--
        function:    Process topicref of the glossary list for sorting
        param:        none
        return:        glossentry topic
        note:        none
    -->
    <xsl:template match="*[contains(@class,' map/topicref ')][@href]" mode="PROCESS_GLOSSARYLIST_TOPICREF_IN_TEMPORARY_TREE">

        <xsl:variable name="topicRef" select="."/>
        <!-- get topic from @href -->
        <xsl:variable name="id" select="substring-after(@href, '#')" as="xs:string"/>
        <xsl:variable name="topicContent"  as="element()?" select="ahf:getTopicFromTopicRef($topicRef)"/>
        <xsl:variable name="titleMode" select="ahf:getTitleMode($topicRef,())" as="xs:integer"/>

        <xsl:choose>
            <xsl:when test="exists($topicContent)">
                <!-- Copy contents -->
                <xsl:apply-templates select="$topicContent" mode="PROCESS_GLOSSENTRY_IN_TEMPORARY_TREE">
                    <xsl:with-param name="prmTopicRef" tunnel="yes" select="$topicRef"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes"
                        select="ahf:replace($stMes070,('%href','%file'),(string(@href),string(@xtrf)))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="#current"/>

    </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')][not(@href)]" mode="PROCESS_GLOSSARYLIST_TOPICREF_IN_TEMPORARY_TREE">
        <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="#current"/>
    </xsl:template>

    <!-- Templates for sorting -->
    <xsl:template match="*[contains(@class,' glossentry/glossentry ')]" mode="PROCESS_GLOSSENTRY_IN_TEMPORARY_TREE">
        <xsl:param name="prmTopicRef" tunnel="yes" as="element()" required="yes"/>

        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="topicRefId" select="ahf:generateId($prmTopicRef,())"/>
            <xsl:attribute name="sortkey">
                <xsl:variable name="tempGlossterm" as="xs:string*">
                    <xsl:apply-templates select="*[contains(@class,' glossentry/glossterm ')]" mode="TEXT_ONLY"/>
                </xsl:variable>
                <xsl:sequence select="string-join($tempGlossterm,'')"/>
            </xsl:attribute>
            <xsl:copy-of select="child::node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class,' glossgroup/glossgroup ')]" mode="PROCESS_GLOSSENTRY_IN_TEMPORARY_TREE">
        <!-- glossgroup or glossentry -->
        <xsl:apply-templates select="*[contains(@class, ' glossgroup/glossgroup ')] | *[contains(@class, ' glossentry/glossentry ')]" mode="#current">
        </xsl:apply-templates>
    </xsl:template>


    <!--
        function:    Process topicref of the glossary list
        param:        none
        return:        call glossentry templates
        note:        none
    -->
    <xsl:template match="*[contains(@class,' map/topicref ')][@href]" mode="PROCESS_GLOSSARYLIST_TOPICREF">
        <!--xsl:param name="prmEditStatus" tunnel="yes" required="yes"/-->

        <xsl:variable name="topicRef" select="."/>
        <!-- get topic from @href -->
        <xsl:variable name="id" select="substring-after(@href, '#')" as="xs:string"/>
        <xsl:variable name="topicContent"  as="element()?" select="ahf:getTopicFromTopicRef($topicRef)"/>
        <xsl:variable name="titleMode" select="ahf:getTitleMode($topicRef,())" as="xs:integer"/>

        <xsl:choose>
            <xsl:when test="exists($topicContent)">
                <!-- Process contents -->
                <xsl:apply-templates select="$topicContent" mode="PROCESS_GLOSSARYLIST_CONTENT">
                    <xsl:with-param name="prmTopicRef" tunnel="yes" select="$topicRef"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="errorExit">
                    <xsl:with-param name="prmMes"
                        select="ahf:replace($stMes070,('%href','%file'),(string(@href),string(@xtrf)))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Process children.-->
        <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="#current"/>

        <!-- generate a class="index-range-end" for metadata -->
        <xsl:call-template name="processIndextermInMetadataEnd">
            <xsl:with-param name="prmTopicRef"     select="$topicRef"/>
            <xsl:with-param name="prmTopicContent" select="$topicContent"/>
        </xsl:call-template>

    </xsl:template>

    <!--
        function:    Process topicref that have no @href attribute
        param:        none
        return:        call lower templates
        note:        none
    -->
    <xsl:template match="*[contains(@class,' map/topicref ')][not(@href)]" mode="PROCESS_GLOSSARYLIST_TOPICREF">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <!--
        function:    Process glossentry
        param:        prmTopicRef
        return:        topic contents
        note:        Changed to output post-note per topic/body. 2011-07-28 t.makita
    -->
    <xsl:template match="*[contains(@class, ' glossentry/glossentry ')]" mode="PROCESS_GLOSSARYLIST_CONTENT" priority="2">
        <xsl:param name="prmTopicRef" tunnel="yes" required="yes" as="element()"/>
        <!--xsl:param name="prmTitleMode"   required="yes" as="xs:integer"/-->

        <div>
            <xsl:call-template name="getAttributeSetWithLang">
                <xsl:with-param name="prmAttrSetName" select="'atsBaseGlossaryList'"/>
                <xsl:with-param name="prmDoInherit" select="true()"/>
            </xsl:call-template>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:call-template name="ahf:getLocalizationAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>

            <div>
                <xsl:call-template name="getAttributeSetWithLang">
                    <xsl:with-param name="prmAttrSetName" select="'atsGlossEntry'"/>
                    <xsl:with-param name="prmDoInherit" select="true()"/>
                </xsl:call-template>

                <!-- glossterm -->
                <xsl:apply-templates select="child::*[contains(@class, ' glossentry/glossterm ')]" mode="#current"/>

                <!-- Inline padding -->
                <xsl:text>&#x00A0;&#x00A0;</xsl:text>

                <!-- glossdef -->
                <xsl:apply-templates select="child::*[contains(@class, ' glossentry/glossdef ')]" mode="#current"/>

                <!-- glossBody -->
                <!--xsl:apply-templates select="child::*[contains(@class, ' glossentry/glossBody ')]">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates-->
            </div>

            <!-- postnote (footnote) -->
            <xsl:if test="child::*[contains(@class, ' glossentry/glossdef ')]">
                <xsl:choose>
                    <xsl:when test="$pDisplayFnAtEndOfTopic">
                        <xsl:call-template name="makePostNote">
                            <xsl:with-param name="prmTopicRef"     select="$prmTopicRef"/>
                            <xsl:with-param name="prmTopicContent" select="child::*[contains(@class,' glossentry/glossdef ')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="makeFootNote">
                            <xsl:with-param name="prmElement"  select="child::*[contains(@class, ' glossentry/glossdef ')]"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

            <!-- related-links -->
            <xsl:apply-templates select="child::*[contains(@class,' topic/related-links ')]"/>

        </div>
    </xsl:template>

    <!--
        function:    Process glossgroup
        param:
        return:        topic contents
        note:
    -->
    <xsl:template match="*[contains(@class, ' glossgroup/glossgroup ')]" mode="PROCESS_GLOSSARYLIST_CONTENT" priority="2">
        <div>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:call-template name="ahf:getLocalizationAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <!-- glossgroup or glossentry -->
            <xsl:apply-templates select="*[contains(@class, ' glossgroup/glossgroup ')] | *[contains(@class, ' glossentry/glossentry ')]" mode="#current"/>
        </div>
    </xsl:template>

    <!--
        function:    glossterm template
        param:        prmTopicRef
        return:        fo:block or descendant generated fo objects
        note:        Apply priority="6" to this template.
    -->
    <xsl:template match="*[contains(@class, ' glossentry/glossterm ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="6">
        <xsl:sequence select="'atsGlossTerm'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' glossentry/glossterm ')]"  mode="PROCESS_GLOSSARYLIST_CONTENT">
        <xsl:param name="prmTopicRef" tunnel="yes" required="yes" as="element()?"/>
        <span>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:call-template name="processIndextermInMetadata">
                <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                <xsl:with-param name="prmTopicContent" select="ancestor::*[contains(@class,' topic/topic ')][1]"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--
        function:    glossdef template
        param:
        return:        fo:block or descendant generated fo objects
        note:        Apply priority="6" to this template.
    -->
    <xsl:template match="*[contains(@class, ' glossentry/glossdef ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="6">
        <xsl:sequence select="'atsGlossDef'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' glossentry/glossdef ')]"  mode="PROCESS_GLOSSARYLIST_CONTENT">
        <span>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>
