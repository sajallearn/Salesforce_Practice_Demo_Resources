#This script is to unzip a zipped file
param(
    [Parameter(Mandatory=$true)]
    [string]$zipfile,

    [Parameter(Mandatory=$true)]
    [string]$outputpath
    )
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$zipfile","$outputpath")