#Throw an error if PerformDeployment is true and PerformValidation is false
if(($env:PerformValidation-eq 'false') -and ($env:PerformDeployment-eq 'true'))
{
    Write-Error 'Deployment Validation should be performed before performing the deployment, Please make PerformValidation variable as true in order to perform the deployment'
}