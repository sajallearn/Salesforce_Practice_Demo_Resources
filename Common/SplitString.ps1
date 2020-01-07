#This script is to split a string based on the given seperator
param(
    [Parameter(Mandatory=$true)]
    [string]$splitstring,
    [Parameter(Mandatory=$true)]
    [string]$seperator
)

$splitwords = $splitstring.Split($seperator,2)
$firstword = $splitwords[0]
$secondword = $splitwords[1]
$firstwordlength = $firstword.Length
$actualstring = $firstword.substring(0,$firstwordlength)
$actualstring

"rollbackfoldername=$actualstring" | Set-Content "$env:WORKSPACE\\Temp\\TempEnv.properties"
"##vso[task.setvariable variable=rollbackfoldername;]$actualstring"
