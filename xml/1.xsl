<xsl:stylesheet version = '1.0'
     xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

  <xsl:template match="/">
    <xsl:call-template name="ben">
      <xsl:with-param name="param1" select="source/a[@id='id_link_to_doc']" /> 
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ben">
    <xsl:param name="param1" />
    <x>
      <param1>
        <xsl:value-of select="$param1" />
      </param1>
      <prec1>
        <xsl:value-of select="$param1/preceding::a[1]" />
      </prec1>
    </x>
  </xsl:template>

</xsl:stylesheet> 

