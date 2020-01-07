REM THis script is to generate package.xml based on git diff
if %DeploymentType%==Partial (
    IF EXIST .\config rmdir /s /q config
    git diff %PreviousShacode% %LatestShacode% | force-dev-tool changeset create . 
    echo 'Package.xml generated successfully'
) else (
   echo 'Full Deployment and no need for generating the package.xml'
)