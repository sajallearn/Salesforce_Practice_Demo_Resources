#This script is to Transform the Build.properties file based on the environment selected
param(
    [Parameter(Mandatory=$true)]
    [string]$buildpropertiesfilepath
)	

#Modify the url,username,password based on the environment from global.propertiesfile and ReadBuildProperties.bat script
#$Salesforce_Password = $env:valuereturned
$Username = 'sf.username=' + $env:Salesforce_Username
$Password = 'sf.password='+ $env:Salesforce_Password
$Serverurl = 'sf.serverurl='+ $env:Salesforce_Url
$maxpoll = 'sf.maxPoll='+$env:properties_maxpoll
$pollwait = 'sf.pollWaitMillis='+$env:properties_pollwait

if ($env:DeploymentType -eq 'Partial')
{
    $deployroot = 'sf.deployRoot='+$env:properties_partialsfdeployroot
    if($env:deploymentfailed -eq 'true')
    {
        $deployroot = 'sf.deployRoot='+$env:properties_rollbackdeployroot
    }
}
elseif ($env:DeploymentType -eq 'Full')
{
    $deployroot = 'sf.deployRoot='+$env:properties_fullsfdeployroot
    if($env:deploymentfailed -eq 'true')
    {
        $deployroot = 'sf.deployRoot='+$env:properties_rollbackdeployroot
    }
}
elseif($env:DeploymentType -eq 'Rollback-Git'){
	$deployroot = 'sf.deployRoot= ../../'+'/Rollback'
}
else
{
    $deployroot = 'sf.deployRoot= ../../'+$env:rollbackfoldername+'/Rollback'
}
#Save the modified contents 

$DeployEnvironment = 'sf.deployEnvironment='+$env:DeployEnvironment

$Username | Set-Content $buildpropertiesfilepath
$Password | Add-Content $buildpropertiesfilepath
$Serverurl | Add-Content $buildpropertiesfilepath
$deployroot | Add-Content $buildpropertiesfilepath
$maxpoll | Add-Content $buildpropertiesfilepath
$pollwait | Add-Content $buildpropertiesfilepath
$DeployEnvironment | Add-Content $buildpropertiesfilepath
"##vso[task.setvariable variable=Salesforce_Password;]$Salesforce_Password"