# Before running this script, make sure to set the following in your PS:
# $ID="Q474563"
# $NAAN="72166"
# $IMAGEURL="https://teylers.adlibhosting.com/wwwopacx/wwwopac.ashx?command=getcontent&amp;server=images&amp;value="

if ([string]::IsNullOrEmpty($ID)) {
	throw 'Please set $ID to the Q number of this customer'
}
if ($null -eq $NAAN) {
	throw 'Please set (ARK) $NAAN of this customer (can be an empty string)'
}
if ([string]::IsNullOrEmpty($IMAGEURL)) {
	throw 'Please set $IMAGEURL to the correct image handler for this customer'
}

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$targetPath = "$scriptDir/../$ID/AxiellWebNDE/xslt/schema.org"
if (-not (Test-Path -Path $targetPath -PathType Container)) {
	throw "Folder '" + $targetPath + "' does not exist."
}


Get-ChildItem "$scriptDir/xslt/schema.org" -Filter *.xslt |
Foreach-Object {
	$targetFile = $targetPath + "/" + $_.Name
	(Get-Content -path $_.FullName -Raw) -replace 'Q666',$ID -replace 'NAAN',$NAAN -replace 'IMAGEURL',$IMAGEURL > $targetFile
	Write-Output $targetFile
}
