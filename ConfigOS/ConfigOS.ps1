###############################################################################
#                         
# -----------------------------------------------------------------------------
# Developer.......: Alexander Ortha (https://www.linkedin.com/in/alexanderortha/)
# Repo............: https://github.com/alexor-ms/AzureArcShow                               
#                 
#                     
# -----------------------------------------------------------------------------
# Summary.........: This script demostrate the first steps of configure a OS
#                   after deployment through Azure at Azure Stack HCI
# 
# -----------------------------------------------------------------------------
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
###############################################################################
###############################################################################

# 1. Install app
# Download 7-Zip
# Check for the latest version of 7-Zip at https://www.7-zip.org/download.html
$7ZIPURL = 'https://www.7-zip.org/a/7z2408-x64.exe'
$7ZIPFolder = 'C:\Windows\Temp\7z2408-x64.exe'
Invoke-WebRequest -Uri $7ZIPURL -OutFile $7ZIPFolder
# Install 7-Zip
Start-Process -FilePath $7ZIPFolder  -ArgumentList "/S"

# 2. Activate using AVMA
powershell.exe -c slmgr /ipk F7TB6-YKN8Y-FCC6R-KQ484-VMK3J

