$FolderToCheck = '.\convert'

Get-ChildItem $FolderToCheck -Filter *.osm | ForEach-Object {
    # declare Xslt script for transformation
    [Xml]$Xslt_script = Get-content 'map_to_svg.xsl'
    # Create Output File Name
    $dir = $_.DirectoryName
    $BaseName = $_.Basename
    # Run the transformation
    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform
    $xslt.Load($Xslt_script)

    $argListStreet = New-Object System.Xml.Xsl.XsltArgumentList 
    $argListStreet.AddParam("target", "", "street")
    $argListBuilding = New-Object System.Xml.Xsl.XsltArgumentList 
    $argListBuilding.AddParam("target", "", "building")
    $argListWater = New-Object System.Xml.Xsl.XsltArgumentList 
    $argListWater.AddParam("target", "", "water")


    $fileNameAll = $_.DirectoryName + '\' + $_.Basename + '.svg'
    $fileNameStreet = $_.DirectoryName + '\' + $_.Basename + '_street.svg'
    $fileNameBuilding = $_.DirectoryName + '\' + $_.Basename + '_building.svg'
    $fileNameWater = $_.DirectoryName + '\' + $_.Basename + '_water.svg'

    $outFileStreet = new-object System.IO.FileStream($fileNameStreet,[System.IO.FileMode]::Create,[System.IO.FileAccess]::Write)
    $outFileBuilding = new-object System.IO.FileStream($fileNameBuilding,[System.IO.FileMode]::Create,[System.IO.FileAccess]::Write)
    $outFileWater = new-object System.IO.FileStream($fileNameWater,[System.IO.FileMode]::Create,[System.IO.FileAccess]::Write)

    $xslt.Transform($_.FullName, $fileNameAll)
    $xslt.Transform($_.FullName, $argListStreet, $outFileStreet)
    $xslt.Transform($_.FullName, $argListBuilding, $outFileBuilding)
    $xslt.Transform($_.FullName, $argListWater, $outFileWater)

    $outFileStreet.Close()
    $outFileBuilding.Close()
    $outFileWater.Close()
}