#This script is to create a new folder in the mentioned path if the folder does not exist
param(
    [Parameter(Mandatory=$true)]
    [string]$directorypath
)
$dir = $directorypath
#Check if folder is present 
if(!(Test-Path -Path $dir )){
    #Create folder
    New-Item -ItemType directory -Path $dir
    Write-Host "New folder created"
}
else
{
  Write-Host "Folder already exists"
}