REM Change the directory to Ant folder
cd %WORKSPACE%\%DevopsFolder%\Ant
REM Perform Deployment
call ant %1
REM Go to Rollback steps if deployment fails
IF %ERRORLEVEL% NEQ 0 goto :ERROR

:EOF 
echo 'Deployment is successful'
exit 0
REM set the deploymentfailed variable to true
:ERROR
echo 'Deployment failed and hence rolling back the changes'
set deploymentfailed=true
@echo ##vso[task.setvariable variable=deploymentfailed;]%deploymentfailed%
exit 0
