#Read the ID of the latest commit that is made on selected branch
$fileContents = get-content $env:WORKSPACE\.git\refs\remotes\origin\$env:Build_SourceBranchName

$EnvVarList = [System.Collections.ArrayList]@()

#Pick up intial 8 characters from the entire commit ID
$revisionid = $fileContents.Substring(0,7)
$EnvVarAdd = "revisionid = ${revisionid}"
$EnvVarList.Add($EnvVarAdd)
#Generate the versionnumber in the form major.minor.buildnumber.revisionid
$EnvVarList.Add($EnvVarAdd)
$date= Get-Date -Format dd-MM-yyyy_HH.mm
$versionnumber = "${env:DeployEnvironment}.${env:properties_majorversion}.${env:properties_minorversion}.$env:BUILD_NUMBER.${revisionid}.${date}"
$EnvVarAdd = "versionnumber = ${versionnumber}"
$EnvVarList.Add($EnvVarAdd)
Write-Output "---------------------------------------------------------------"

Write-Output "Version number is : $versionnumber"

Write-Output "---------------------------------------------------------------"

$EnvVarList | Set-Content "./Temp/TempEnv.properties"