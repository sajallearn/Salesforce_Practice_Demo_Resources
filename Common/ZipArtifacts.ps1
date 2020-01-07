#This script is to zip the artifacts folder
param(
    [Parameter(Mandatory=$true)]
    [string]$FolderName
)

$ErrorActionPreference="Stop"

$source = ".\Artifacts\$env:DeployEnvironment\$FolderName"

move-item -path ".\Artifacts\$env:DeployEnvironment\SFDCRetrieve" -destination ".\Artifacts\$env:DeployEnvironment\$FolderName"

$destination = ".\Artifacts\$env:DeployEnvironment\$FolderName.zip"

 If(Test-path $destination) {Remove-item $destination}

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::CreateFromDirectory($source, $destination) 