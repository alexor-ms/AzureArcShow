<#
    =================================================================================
    DISCLAIMER:
    This script is provided "as-is" with no warranties. Usage of this script is at
    your own risk. The author is not liable for any damages or losses arising from
    using this script.
    =================================================================================
#>
# Script based on https://support.microsoft.com/en-us/topic/kb5025175-updating-the-winre-partition-on-deployed-devices-to-address-security-vulnerabilities-in-cve-2022-41099-ba6621fa-5a9f-48f1-9ca3-e13eb56fb589

# Download the updated packege from Windows Update Catalog https://www.catalog.update.microsoft.com/Search.aspx?q=Safe%20OS
$UPDATEURL = 'https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/crup/2024/01/windows10.0-kb5034235-x64_56366bb71884fc21c948c37ed3341f74aaf6b296.cab'
$SourceFolder = 'C:\windows\Temp\windows10.0-kb5034235-x64_56366bb71884fc21c948c37ed3341f74aaf6b296.cab'
Invoke-WebRequest -Uri $UPDATEURL -OutFile $SourceFolder

# Script provided in the KB article above and ready to download from my personal Github repo 
$UPDATEPSURL = 'https://raw.githubusercontent.com/alexor-ms/AzureArcShow/main/Patch_KB5034439/PatchWinREScript_2004plus.ps1'
$SourceFolder = 'C:\windows\Temp\PatchWinREScript_2004plus.ps1'
Invoke-WebRequest -Uri $UPDATEPSURL -OutFile $SourceFolder

# Execute PS script
C:\windows\Temp\PatchWinREScript_2004plus.ps1 -packagePath .\windows10.0-kb5034235-x64_56366bb71884fc21c948c37ed3341f74aaf6b296.cab

# Reboot machine
shutdown /r /f /t 0
