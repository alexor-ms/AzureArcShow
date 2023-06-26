###############################################################################
#                         
# -----------------------------------------------------------------------------
# Developer.......: Alexander Ortha (https://www.linkedin.com/in/alexanderortha/)
# Repo............: https://github.com/alexor-ms/AzureArcShow                               
#                 
#                     
# -----------------------------------------------------------------------------
# Summary.........: This script helps to keep Azure CLI & Extension up to date .... It is just a starter and some manual
#                   stuff needs to be done.
#                   Please execute script step-by-step as there is no
#                   error handling yet.
# -----------------------------------------------------------------------------
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
###############################################################################
###############################################################################

# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli
# enable and deploy Azure CLI
# ALWAYS UPDATE CLI !!!!!!
#

az version
<#{
  "azure-cli": "2.25.0",
  "azure-cli-core": "2.25.0",
  "azure-cli-telemetry": "1.0.6",
  "extensions": {
    "connectedk8s": "1.1.5",
    "customlocation": "0.1.2",
    "k8s-configuration": "1.0.0",
    "k8s-extension": "0.4.3"
  }
}
#>

# Upgrade Azure CLI
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi


az upgrade
<#This command is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus
Your current Azure CLI version is 2.25.0. Latest version available is 2.26.0.
Please check the release notes first: https://docs.microsoft.com/cli/azure/release-notes-azure-cli
Do you want to continue? (Y/n): y
Upgrading extensions
Checking update for connectedk8s
No updates available for 'connectedk8s'. Use --debug for more information.
Checking update for customlocation
No updates available for 'customlocation'. Use --debug for more information.
Checking update for k8s-configuration
No updates available for 'k8s-configuration'. Use --debug for more information.
Checking update for k8s-extension
Upgrade finished.You can enable auto-upgrade with 'az config set auto-upgrade.enable=yes'. More details in https://docs.microsoft.com/cli/azure/update-azure-cli#automatic-update
#>
az version
<#{
  "azure-cli": "2.26.0",
  "azure-cli-core": "2.26.0",
  "azure-cli-telemetry": "1.0.6",
  "extensions": {
    "connectedk8s": "1.1.5",
    "customlocation": "0.1.2",
    "k8s-configuration": "1.0.0",
    "k8s-extension": "0.5.1"
  }
}
#>

az extension add --upgrade --name arcappliance
az extension add --upgrade --name connectedk8s
az extension add --upgrade --name k8s-configuration
az extension add --upgrade --name k8s-extension
az extension add --upgrade --name customlocation
az extension add --upgrade --name azurestackhci
az extension add --upgrade --name account
az extension add --upgrade --name arcdata
az extension add --upgrade --name connectedvmware
az extension add --upgrade --name arcappliance
az extension add --upgrade --name hybridaks
