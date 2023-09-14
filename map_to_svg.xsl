<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:svg="http://www.w3.org/2000/svg"

>

  <xsl:output method="xml"/>
  <xsl:param name="target" select="'all'"/>

  <xsl:variable name="SCALE" select="100000"></xsl:variable>
  <xsl:variable name="COLOR_STREET" select="'black'"></xsl:variable>
  <xsl:variable name="COLOR_WATER" select="'#cccccc'"></xsl:variable>
  <xsl:variable name="COLOR_BUILDING" select="'#666666'"></xsl:variable>

  <xsl:template match="/">
    <xsl:variable name="min_long">
        <xsl:value-of select="/osm/bounds/@minlon" />
    </xsl:variable>
    <xsl:variable name="max_long">
        <xsl:value-of select="/osm/bounds/@maxlon" />
    </xsl:variable>
    <xsl:variable name="min_lat">
        <xsl:value-of select="/osm/bounds/@minlat" />
    </xsl:variable>
    <xsl:variable name="max_lat">
        <xsl:value-of select="/osm/bounds/@maxlat" />
    </xsl:variable>

    <svg
        width="{ ($max_long - $min_long) * $SCALE }"
        height="{ ($max_lat - $min_lat) * $SCALE }"
        xmlns="http://www.w3.org/2000/svg"
    >
        <xsl:apply-templates select="//way">
            <xsl:with-param name="target" select="$target" />
        </xsl:apply-templates>
    </svg>
  </xsl:template>
 <!-- <bounds minlat="52.0148900" minlon="8.5351300" maxlat="52.0177100" maxlon="8.5434300"/> -->



  <xsl:template match="way">
    <xsl:choose>
        <xsl:when test="($target='all' or $target='street') and ./tag[@k='highway' and (@v='secondary' or @v='tertiary' or @v='residential' or @v='footway')]">
            <xsl:call-template name="street"></xsl:call-template>
        </xsl:when>
        <xsl:when test="($target='all' or $target='water') and ./tag[@k='waterway']">
            <xsl:call-template name="waterway"></xsl:call-template>
        </xsl:when>
        <xsl:when test="($target='all' or $target='water') and ./tag[@k='water']">
            <xsl:call-template name="water"></xsl:call-template>
        </xsl:when>
        <xsl:when test="($target='all' or $target='building') and ./tag[@k='building' or @k='demolished:building']">
            <xsl:call-template name="building"></xsl:call-template>
        </xsl:when>
    </xsl:choose>
  </xsl:template>

    

    <xsl:template name="building">
        <polygon fill="{$COLOR_BUILDING}">
            <xsl:attribute name="points">
                <xsl:for-each select="./nd">
                    <xsl:variable name="nd_ref" select="@ref" />
                    <xsl:variable name="max_lat" select="/osm/bounds/@maxlat" />
                    <xsl:variable name="min_long" select="/osm/bounds/@minlon" />

                    <xsl:value-of select="(//node[@id=$nd_ref]/@lon - $min_long) * $SCALE" />,<xsl:value-of select="( $max_lat - //node[@id=$nd_ref]/@lat) * $SCALE" /><xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:attribute>
        </polygon>
    </xsl:template>

    <xsl:template name="street">
        <xsl:variable name="stroke_width">
            <xsl:choose>
                <xsl:when test="./tag[@k='highway']/@v='tertiary'">
                    <xsl:text>10px</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>5px</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <polyline fill="none" stroke="{$COLOR_STREET}" stroke-width="{$stroke_width}">
            <xsl:attribute name="street_name">
                <xsl:value-of select="./tag[@k='name']/@v" />
            </xsl:attribute>
            <xsl:attribute name="points">
                <xsl:for-each select="./nd">
                    <xsl:variable name="nd_ref" select="@ref" />
                    <xsl:variable name="max_lat" select="/osm/bounds/@maxlat" />
                    <xsl:variable name="min_long" select="/osm/bounds/@minlon" />

                    <xsl:value-of select="(//node[@id=$nd_ref]/@lon - $min_long) * $SCALE" />,<xsl:value-of select="( $max_lat - //node[@id=$nd_ref]/@lat) * $SCALE" /><xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:attribute>
        </polyline>
    </xsl:template>

    <xsl:template name="waterway">
        <polyline fill="none" stroke="{$COLOR_WATER}" stroke-width="5px">
            <xsl:attribute name="points">
                <xsl:for-each select="./nd">
                    <xsl:variable name="nd_ref" select="@ref" />
                    <xsl:variable name="max_lat" select="/osm/bounds/@maxlat" />
                    <xsl:variable name="min_long" select="/osm/bounds/@minlon" />

                    <xsl:value-of select="(//node[@id=$nd_ref]/@lon - $min_long) * $SCALE" />,<xsl:value-of select="( $max_lat - //node[@id=$nd_ref]/@lat) * $SCALE" /><xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:attribute>
        </polyline>
    </xsl:template>


    <xsl:template name="water">
        <polygon fill="{$COLOR_WATER}">
            <xsl:attribute name="points">
                <xsl:for-each select="./nd">
                    <xsl:variable name="nd_ref" select="@ref" />
                    <xsl:variable name="max_lat" select="/osm/bounds/@maxlat" />
                    <xsl:variable name="min_long" select="/osm/bounds/@minlon" />

                    <xsl:value-of select="(//node[@id=$nd_ref]/@lon - $min_long) * $SCALE" />,<xsl:value-of select="( $max_lat - //node[@id=$nd_ref]/@lat) * $SCALE" /><xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:attribute>
        </polygon>
    </xsl:template>


</xsl:stylesheet>