<#
    =================================================================================
    DISCLAIMER:
    This script is provided "as-is" with no warranties. Usage of this script is at
    your own risk. The author is not liable for any damages or losses arising from
    using this script.
    =================================================================================
#>
# Script based on https://support.microsoft.com/en-us/topic/kb5025175-updating-the-winre-partition-on-deployed-devices-to-address-security-vulnerabilities-in-cve-2022-41099-ba6621fa-5a9f-48f1-9ca3-e13eb56fb589
# Script provided in the KB article above and ready to download from my personal Github repo 
$UPDATEPSURL = 'https://raw.githubusercontent.com/alexor-ms/AzureArcShow/main/Patch_KB5034439/Patch_KB5034439.txt'
$SourceFolder = 'C:\windows\Temp\Patch_KB5034439.txt'
Invoke-WebRequest -Uri $UPDATEPSURL -OutFile $SourceFolder

reagentc /info
reagentc /disable
DISKPART /s C:\windows\Temp\Patch_KB5034439.txt
reagentc /enable
reagentc /info

# Reboot machine
shutdown /r /f /t 0
