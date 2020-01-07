param(
    [Parameter(Mandatory=$true)]
    [string]$buildxmlpath,
	
    [Parameter(Mandatory=$true)]
    [string]$targetname
)

$path = $buildxmlpath
[xml]$xml = New-Object system.Xml.XmlDocument
[xml]$xml = Get-Content $path
$node = $xml | Select-Xml -Xpath "//target[@name='$targetname']" | Select-Object -ExpandProperty "node"
$node.deploy.SetAttribute("testLevel","")

if($env:RunLocalTests -eq "Specified")
{
    if($env:TestClassNames -eq 'null')
    {
        Write-Error "Test Class Names should be provided when RunLocalTests is selected as Specified"
    }
    $node.deploy.testLevel = "RunSpecifiedTests"
    $xml.Save($path)
    $env:TestClassNames.Split(',') | ForEach {
    [xml]$xml = New-Object system.Xml.XmlDocument
    [xml]$xml = Get-Content $path
    $tempnode = $xml | Select-Xml -Xpath "//target[@name='$targetname']" | Select-Object -ExpandProperty "node"
    $w = $tempnode.deploy
    $abc = $xml.CreateElement("runTest")
    $xmlText = $xml.CreateTextNode($_)
    $abc.AppendChild($xmlText)
    [void]$w.AppendChild($abc)
    $xml.OuterXml
    $xml.Save($path)
    }
    
 }
 elseif ($env:RunLocalTests -eq "true")
 {
	
    $node.deploy.testLevel = "RunLocalTests"
    
    $xml.Save($path)
 }
 elseif ($env:RunLocalTests -eq "false")
 {
	Write-Host "RunLocalTests false"

    $child = $node.deploy
	$child.RemoveAttribute('testLevel')
    $xml.Save($path)
 }

