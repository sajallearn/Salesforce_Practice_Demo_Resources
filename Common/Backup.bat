REM This script is for creating artifacts folder with the current deployment code ,backup code and shacode.properties file.
REM Delete the respective DeployEnvironment folder in Artifacts directory if that exists
set Build_Repository_LocalPath=.
IF [%LatestShacode%]==[] (set LatestShacode=HEAD)
echo LatestShaCode is %LatestShacode%
IF EXIST %Build_Repository_LocalPath%\Artifacts\%DeployEnvironment% rmdir /s /q %Build_Repository_LocalPath%\Artifacts\%DeployEnvironment%
REM Delete the retrieve Unpackaged folder if it exists
IF EXIST %Build_Repository_LocalPath%\%DevopsFolder%\Ant\retrieveUnpackaged rmdir /s /q %Build_Repository_LocalPath%\%DevopsFolder%\Ant\retrieveUnpackaged
REM Create Deployment,Rollback and Logs folder in Artifacts->DeployEnvironment->version directory
mkdir %Build_Repository_LocalPath%\Artifacts\%DeployEnvironment%\%versionnumber%\Deployment;%Build_Repository_LocalPath%\Artifacts\%DeployEnvironment%\%versionnumber%\Logs
REM Copy the code from config->deployments to Artifacts->DeployEnvironment->version->Deployment
xcopy %Build_Repository_LocalPath%\config\deployments %Build_Repository_LocalPath%\Artifacts\%DeployEnvironment%\%versionnumber%\Deployment /Y /E
REM Copy the Shaocde.properties file from Devops Repository Folder->DeploymentLogs->DeployEnvironment to Artifacts->
copy /y %Build_Repository_LocalPath%\%DevopsFolder%\DeploymentLogs\%RepositoryName%\%DeployEnvironment%\%DeployEnvironment%_Shacode.properties %Build_Repository_LocalPath%\Artifacts\%DeployEnvironment%\%versionnumber%\Logs
REM Take Backup of the code from the org before deployment and place in Rollback folder of artifacts
git diff %LatestShacode% %PreviousShacode% | force-dev-tool changeset create Rollback 
move %Build_Repository_LocalPath%\config\deployments\Rollback %Build_Repository_LocalPath%\Artifacts\%DeployEnvironment%\%versionnumber%
echo %PreviousShacode%
REM Get the diff of modified/added/deleted file names between previous shacode and latest shacode
cd %Build_Repository_LocalPath%
git diff --name-status %PreviousShacode% %LatestShacode%>>%Build_Repository_LocalPath%\Artifacts\%DeployEnvironment%\%versionnumber%\Logs\Deploymentfiles.txt


