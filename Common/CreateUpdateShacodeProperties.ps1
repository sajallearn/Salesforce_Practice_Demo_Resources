#THis script is to update the Shacode.properties file based on various conditions
param(
    [Parameter(Mandatory=$true)]
    [string]$Shacodefilepath,
	
	[Parameter(Mandatory=$true)]
    [string]$Shacodefilename
	
)	
#This is a function to read the Shacode.properties file and seperate them based on key,value pair
function Read-Propertyfile([string]$filepath)
{
	$fileContents = get-content $filepath
	$shacodeproperties = @{}
	foreach($line in $fileContents)
	{
		  write-host $line
		  # ,2 tells split to return two substrings (a single split) per line
		  $words = $line.Split('=',2)
		  $shacodeproperties.add($words[0].Trim(), $words[1].Trim())
	}
	return $shacodeproperties
}
#Check if the Shacode.properties file is already present for particular Environment
$versionnumber = "$env:versionnumber"
echo "Version Number is $versionnumber"
if (!(Test-Path $Shacodefilepath\$Shacodefilename))
{
	#Create a new file with name Environment_Shacode.properties 
   New-Item -path $Shacodefilepath -Name $Shacodefilename -Itemtype "file"
   Write-Host "Created new file"
   #Assign the values for Branch,Latestcode,Previouscode,Version,TypeofDeployment,PreviousVersion
   $Branch = 'Branch=' + $env:Build_SourceBranchName
   $Latestcode = 'LatestShacode='+ $env:revisionid
   $Previouscode = 'PreviousShacode='+ ''
   $Version = 'Version='+ $env:versionnumber
   echo "Version is $Version"
   $TypeofDeployment = 'TypeofDeployment='+ $env:DeploymentType
   $Previousversion = 'PreviousVersion='
   
   $Branch | Set-Content $Shacodefilepath\$Shacodefilename
   $Latestcode | Add-Content $Shacodefilepath\$Shacodefilename
   $Previouscode | Add-Content $Shacodefilepath\$Shacodefilename
   $Version | Add-Content $Shacodefilepath\$Shacodefilename
   $TypeofDeployment | Add-Content $Shacodefilepath\$Shacodefilename
   $Previousversion | Add-Content $Shacodefilepath\$Shacodefilename
   
}
else
{
	#If file already exists, modify the values accordinlgy
	'File exists already'
	$shacodeproperties = Read-Propertyfile $Shacodefilepath\$Shacodefilename
	
	#Read the values of Branch,Version,LatestShacode
	$OldBranch = $shacodeproperties.Branch
	$oldVersion = $shacodeproperties.Version
	$oldShacode = $shacodeproperties.LatestShacode

	#Change the Branch Name to the selected Branch
	$Branch = 'Branch=' + $env:Build_SourceBranchName
	#Change the LatestShacode to the latest commit ID on particular branch
	$Latestcode = 'LatestShacode='+ $env:revisionid
	#Change the PreviousShacode to the value that we read previously from LatestShacode and that we stored in variable $oldShacode
	$Previouscode = 'PreviousShacode='+ $oldShacode
	#Change ther Version to the generated version number in the form of major.minor.buildnumber.shacode
	$Version = 'Version='+ $env:versionnumber
	#Change the PreviousVersion to the value that we read previously from Version and that we stored in variable $oldVersion
	$PreviousVersion = 'PreviousVersion ='+$oldVersion
	#Chane the TypeofDeployment to the select TypeofDeployment
	$TypeofDeployment = 'TypeofDeployment='+ $env:DeploymentType
	
	#Save the modified values
	$Branch | Set-Content $Shacodefilepath\$Shacodefilename
	$Latestcode | Add-Content $Shacodefilepath\$Shacodefilename
	$Previouscode | Add-Content $Shacodefilepath\$Shacodefilename
	$Version | Add-Content $Shacodefilepath\$Shacodefilename
	$PreviousVersion | Add-Content $Shacodefilepath\$Shacodefilename
	$TypeofDeployment | Add-Content $Shacodefilepath\$Shacodefilename
}
$shacodeproperties = Read-Propertyfile $Shacodefilepath\$Shacodefilename
Write-Output "Cha Code Property is "
$shacodeproperties
#Check if Old Branch is same the new Branch
if(!($OldBranch -eq $env:Build_SourceBranchName))
{
	#Perform these operations if the branch is changed

	'Git Branch is changed'
	#Mandate the user to mention PreviousCommitID if the branch is changed ,if PreviousCommitID is not mentioned, throw an error message
	if($env:PreviousCommitID -eq 'null')
	{
		'Previous Commit ID is mandatory'
		Write-Error 'Previous Commit ID is mandatory when branch is changed'
	}
	else
	{
		#If Previous Commit ID is mentioned while triggering the build definition, assign that value to PreviousShacode in Shacode.properties file
		$PreviousShacode = $env:PreviousCommitID
		if(!($env:LatestCommitID -eq 'null'))
		{
			$LatestShacode = $env:LatestCommitID
			$changedversion = "$env:properties_majorversion.$env:properties_minorversion.$env:BUILD_NUMBER.$LatestShacode"
			$versionnumber = $changedversion
			$changingversion = 'Version='+$changedversion
			$changeddversion = $shacodeproperties.Version
			# Code for updating LatestShacode in shacode.properties file
			$Latestcode = 'LatestShacode='+ $env:LatestCommitID
			$oldcode = $shacodeproperties.LatestShacode
			$Replacecode = 'LatestShacode='+$oldcode
			(Get-Content $Shacodefilepath\$Shacodefilename).replace($Replacecode,$Latestcode) | Set-Content $Shacodefilepath\$Shacodefilename
			(Get-Content $Shacodefilepath\$Shacodefilename).replace($changeddversion,$changingversion) | Set-Content $Shacodefilepath\$Shacodefilename
		}
		$shacodeproperties = Read-Propertyfile $Shacodefilepath\$Shacodefilename
		#If Latest Commit ID is mentioned while triggering the build definition, assign that value to LatestShaCode in Shacode.properties file
		$LatestShacode = $shacodeproperties.LatestShacode
		
		# Code for updating PreviousShacode in shacode.properties file
		
		$latestline = 'PreviousShacode='+$env:PreviousCommitID
		$oldshacode = $shacodeproperties.PreviousShacode
		$oldline = 'PreviousShacode='+$oldshacode
		(Get-Content $Shacodefilepath\$Shacodefilename).replace($oldline,$latestline) | Set-Content $Shacodefilepath\$Shacodefilename
		
		
	}
	
}
else
{
	#Perform these operations if the branch is not changed
	'Branch is not changed' 
	if($env:PreviousCommitID -eq 'null')
	{
		$shacodeproperties = Read-Propertyfile $Shacodefilepath\$Shacodefilename
		$PreviousShacode = $shacodeproperties.PreviousShacode
	}
	else
	{
		# Code for updating PreviousShacode in shacode.properties file
		$PreviousShacode = $env:PreviousCommitID
		if($env:UpdateShacodefile -eq 'true')
		{
			$latestline = 'PreviousShacode='+$env:PreviousCommitID
			$oldshacode = $shacodeproperties.PreviousShacode
			$oldline = 'PreviousShacode='+$oldshacode
			(Get-Content $Shacodefilepath\$Shacodefilename).replace($oldline,$latestline) | Set-Content $Shacodefilepath\$Shacodefilename
		}
		
	}
	# Code for updating LatestShacode in shacode.properties file
	if($env:LatestCommitID -eq 'null')
	{
		$shacodeproperties = Read-Propertyfile $Shacodefilepath\$Shacodefilename
		$LatestShacode = $shacodeproperties.LatestShacode
	}
	else
	{
		$LatestShacode = $env:LatestCommitID
		$changedversion = "$env:properties_majorversion.$env:properties_minorversion.$env:BUILD_NUMBER.$LatestShacode"
		$versionnumber = $changedversion
		if($env:UpdateShacodefile -eq 'true')
		{
			$latestline = 'LatestShacode='+$env:LatestCommitID
			$changingversion = 'Version='+$changedversion
			$changeddversion = $shacodeproperties.Version
			$oldshacode = $shacodeproperties.LatestShacode
			$oldline = 'LatestShacode='+$oldshacode
			(Get-Content $Shacodefilepath\$Shacodefilename).replace($oldline,$latestline) | Set-Content $Shacodefilepath\$Shacodefilename
			(Get-Content $Shacodefilepath\$Shacodefilename).replace($changeddversion,$changingversion) | Set-Content $Shacodefilepath\$Shacodefilename
		}
	}
}
$LatestShacode
$PreviousShacode
#"##vso[task.setvariable variable=LatestShacode;]$LatestShacode"
#"##vso[task.setvariable variable=PreviousShacode;]$PreviousShacode"
#"##vso[task.setvariable variable=versionnumber;]$versionnumber"

$EnvVarList = [System.Collections.ArrayList]@()

$EnvVarAdd = "LatestShaCode = $LatestShacode"
$EnvVarList.Add($EnvVarAdd)

$EnvVarAdd = "PreviousShacode = $PreviousShacode"
$EnvVarList.Add($EnvVarAdd)

$EnvVarAdd = "versionnumber = $versionnumber"
$EnvVarList.Add($EnvVarAdd)
					
$EnvVarList | Set-Content "./Temp/TempEnv.properties"
#Throw an error if both PreviousShacode and LatestShaCode are the same,because there will be no changes to deploy
if($env:DeploymentType -eq 'Partial')
{
	'Deployment is Partial'
	if($LatestShacode -eq $PreviousShacode)
	{
		'LatestShacode is :'+ $LatestShacode
		'Previous Deployed Shacode is :'+$PreviousShacode
		'Previous Shacode and Latest Shacode is the same and there are no changes to deploy'
		Write-Error 'Previous Shacode and Latest Shacode is the same and there are no changes to deploy,hence exiting the build'
	}
}