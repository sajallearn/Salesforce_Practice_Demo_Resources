#This script is to read the properties file specified and return the values. 
param(
    [Parameter(Mandatory=$true)]
    [string]$propertiespath
)

$FileContent = Get-Content $propertiespath
 $FinalContentList = [System.Collections.ArrayList]@()
                        
 foreach($line in $FileContent){
	if(!$line.Contains("#") -and $line.Contains("=")){
		$line = "properties_" + $line 
		$FinalContentList.Add($line)
    }
}

$FinalContentList | Set-Content "$env:WORKSPACE\\Temp\\TempEnv.properties"