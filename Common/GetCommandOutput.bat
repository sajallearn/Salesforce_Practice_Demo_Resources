REM Execute a batch command and store the output to a variable
SETLOCAL EnableDelayedExpansion
REM set secretkey=%2 
set command="%1 input=%Salesforce_EncryptedPassword% password=%2"
echo command is %command%
FOR /F "tokens=*" %%i IN ('%command%') DO SET X=%%i
echo %X%
REM @echo ##vso[task.setvariable variable=valuereturned;]%X%
echo Salesforce_Password = %X% > ./Temp/TempEnv.properties
