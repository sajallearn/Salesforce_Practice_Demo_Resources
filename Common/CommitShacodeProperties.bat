 echo on
set shacodepropertiespath=%1
 echo ShaCode Properties Path is %shacodepropertiespath%
 SETLOCAL EnableDelayedExpansion
 REM Move from code checkout directory to Build Directory
 set CommitDirPath="%WORKSPACE%"
 cd %CommitDirPath%
 REM Create a folder with the name of that particular sandbox Devops folder if it does not exist
 REM FROM GOlbal Properties
 set CommitDir=commitRepo
 echo CommitDir is %CommitDir%
 if not exist "%CommitDir%" mkdir "%CommitDir%"
 REM Move to the newly created folder
 cd %CommitDirPath%\\%CommitDir%
 (
	cd
 	REM Clone the code from Devops Repository(BraveMoose_Devops)
 	REM git clone %devopsurl% .
 	REM Get the latest Code from the Develop Branch
 	REM  git checkout .
 	REM git pull
 	REM git checkout %properties_devopsbranch%
 	REM Configure the username and email
 	git config --local user.email %useremail%
 	git config --local user.name %username%
 	type .git\\config
 	git pull origin master
	git checkout master
 	REM Create a folder for the corresponding Environment in BuildDirectory -> Devops Folder ->DeploymentLogs -> RepositoryName
 	if not exist %CommitDirPath%\\%CommitDir%\\DeploymentLogs\\%RepositoryName%\\%DeployEnvironment% mkdir %CommitDirPath%\\%CommitDir%\\DeploymentLogs\\%RepositoryName%\\%DeployEnvironment%
 	REM copy the updated Shacode.properties from BuildRepositoryLocalPath->Devops Folder->DeploymentLogs->RepositoryName ->Environment to BuildDirectory->Devops Folder->DeploymentLogs-> RepositoryName->Environment
 	copy /y %shacodepropertiespath% %CommitDirPath%\\%CommitDir%\\DeploymentLogs\\%RepositoryName%\\%DeployEnvironment%\\%DeployEnvironment%_Shacode.properties
 	REM Stage the copied file
 	git add %CommitDirPath%\\%CommitDir%\\DeploymentLogs\\%RepositoryName%\\%DeployEnvironment%\\%DeployEnvironment%_Shacode.properties
 	git status
 	git checkout master
 	REM Commit the Shacode.properties file
 	git commit -m "Committing Shacode.properties for version : %versionnumber%"
 	git status
 	REM Push the changes to Devops Repository
 	git push origin 
 )