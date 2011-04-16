<!--

XSLT script to format SPARQL Query Results XML Format into xhtml

Copyright © 2004, 2005 World Wide Web Consortium, (Massachusetts
Institute of Technology, European Research Consortium for
Informatics and Mathematics, Keio University). All Rights
Reserved. This work is distributed under the W3C® Software
License [1] in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.

[1] http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231

$Id: result2-to-html.xsl,v 1.1 2007/06/14 15:40:40 eric Exp $

modified by Mischa Tuffield to output json on 20110416T12:00:00Z

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:res="http://www.w3.org/2005/sparql-results#"
  exclude-result-prefixes="res xsl">

  <xsl:output
    method="xml" 
    indent="yes"
    encoding="UTF-8" 
    omit-xml-declaration="yes" />

  <xsl:template name="vb-result">
	<xsl:for-each select="res:results/res:result">
	<xsl:variable name="current" select="."/>
    {
          <xsl:for-each select="//res:head/res:variable"> 
		<xsl:variable name="name" select="@name"/>
        "<xsl:value-of select="$name"/>" : "<xsl:apply-templates select="$current/res:binding[@name=$name]"/>" <xsl:choose> <xsl:when test="not(position() = last())"> , </xsl:when> </xsl:choose>
          </xsl:for-each> 
    } <xsl:choose> <xsl:when test="not(position() = last())"> , </xsl:when> </xsl:choose> 
	</xsl:for-each>
  </xsl:template>

  <xsl:template match="res:result">
    <xsl:variable name="current" select="."/>
    <xsl:for-each select="//res:head/res:variable">
      <xsl:variable name="name" select="@name"/>
	<xsl:choose>
	  <xsl:when test="$current/res:binding[@name=$name]">
	    <!-- apply template for the correct value type (bnode, uri,
	    literal) -->
	    <xsl:apply-templates select="$current/res:binding[@name=$name]"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <!-- no binding available for this variable in this solution -->
	    [unbound]
	  </xsl:otherwise>
	</xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="res:bnode">
    <xsl:text>nodeID </xsl:text>
    <xsl:value-of select="text()"/>
  </xsl:template>

  <xsl:template match="res:uri">
    <xsl:variable name="uri" select="text()"/>
    <xsl:text>URI </xsl:text>
    <xsl:value-of select="$uri"/>
  </xsl:template>

  <xsl:template match="res:literal">
    <xsl:choose>
      <xsl:when test="@datatype">

	<!-- datatyped literal value -->
	<xsl:value-of select="text()"/> (datatype <xsl:value-of select="@datatype"/> )
      </xsl:when>
      <xsl:when test="@xml:lang">
	<!-- lang-string -->
	<xsl:value-of select="text()"/> @ <xsl:value-of select="@xml:lang"/>
      </xsl:when>

      <xsl:when test="string-length(text()) != 0">
	<!-- present and not empty -->
	<xsl:value-of select="text()"/>
      </xsl:when>
      <xsl:when test="string-length(text()) = 0">
	<!-- present and empty -->
	[empty literal]
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="res:sparql">
[
    <xsl:call-template name="vb-result" />
]

  </xsl:template>
</xsl:stylesheet>
