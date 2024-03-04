$UPDATEURL = 'https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/crup/2024/01/windows10.0-kb5034235-x64_56366bb71884fc21c948c37ed3341f74aaf6b296.cab'
$SourceFolder = 'C:\windows\Temp\windows10.0-kb5034235-x64_56366bb71884fc21c948c37ed3341f74aaf6b296.cab'
Invoke-WebRequest -Uri $UPDATEURL -OutFile $SourceFolder


$UPDATEPSURL = 'https://raw.githubusercontent.com/alexor-ms/AzureArcShow/main/Patch_KB5034439/PatchWinREScript_2004plus.ps1'
$SourceFolder = 'C:\windows\Temp\PatchWinREScript_2004plus.ps1'
Invoke-WebRequest -Uri $UPDATEPSURL -OutFile $SourceFolder

C:\windows\Temp\PatchWinREScript_2004plus.ps1 -packagePath .\windows10.0-kb5034235-x64_56366bb71884fc21c948c37ed3341f74aaf6b296.cab
