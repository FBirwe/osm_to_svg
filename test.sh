# Auszüge erstellen
xsltproc --stringparam target building map_to_svg.xsl $1.osm > "${1}_building.svg"
xsltproc --stringparam target street map_to_svg.xsl $1.osm > "${1}_street.svg"
xsltproc --stringparam target water map_to_svg.xsl $1.osm > "${1}_water.svg"

# Gesamtausgabe
xsltproc --stringparam target all map_to_svg.xsl $1.osm > $1.svg