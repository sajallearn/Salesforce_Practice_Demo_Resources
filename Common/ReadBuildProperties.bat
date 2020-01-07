REM This script is to read the salesforce url, username,password based on the environment using delayed expansion and return the values for transformation
echo on
SETLOCAL EnableDelayedExpansion

REM Combine the variables using Delayed Expansion
set Join_Salesforce_username=properties_%DeployEnvironment%_sfusername
set Join_Salesforce_password=properties_%DeployEnvironment%_sfpassword
set Join_Salesforce_url=properties_%DeployEnvironment%_sfserverurl

REM Read the value corresponding to the combined variable
set Salesforce_Username=!%Join_Salesforce_username%!
set Salesforce_EncryptedPassword=!%Join_Salesforce_password%!
set Salesforce_Url=!%Join_Salesforce_url%!



echo %Salesforce_Username%
echo %Salesforce_EncryptedPassword%
echo %Salesforce_Url%

echo Salesforce_Username = %Salesforce_Username% > ./Temp/TempEnv.properties 
echo Salesforce_EncryptedPassword = %Salesforce_EncryptedPassword% >> ./Temp/TempEnv.properties
echo Salesforce_Url = %Salesforce_Url% >> ./Temp/TempEnv.properties