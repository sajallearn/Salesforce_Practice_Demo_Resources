REM Delete the desturctiveChanges.xml file if the user specifies to
if %RemoveDestructiveChanges%==true (
    IF EXIST %Build_Repository_LocalPath%\config\deployments\destructiveChanges.xml DEL /F %Build_Repository_LocalPath%\config\deployments\destructiveChanges.xml 
) else (
   echo 'Including the destructive changes'
)