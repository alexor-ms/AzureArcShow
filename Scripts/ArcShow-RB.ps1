###############################################################################
#                         
# -----------------------------------------------------------------------------
# Developer.......: Alexander Ortha (https://www.linkedin.com/in/alexanderortha/)
# Repo............: https://github.com/alexor-ms/AzureArcShow                               
#                 
#                     
# -----------------------------------------------------------------------------
# Summary.........: This script helps setting up Azure Arc Resource Bridge .... It is just a starter and some manual
#                   stuff needs to be done.
#                   Please execute script step-by-step as there is no
#                   error handling yet.
# -----------------------------------------------------------------------------
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
###############################################################################
###############################################################################

# Azure Show Arc Resource Bridge
# https://learn.microsoft.com/en-us/azure-stack/hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address

# Prep ALL hosts
# Check Azure CLI
az version
# CLI extensions
az extension add --upgrade --name arcappliance
az extension add --upgrade --name connectedk8s
az extension add --upgrade --name k8s-configuration
az extension add --upgrade --name k8s-extension
az extension add --upgrade --name customlocation
az extension add --upgrade --name azurestackhci

# Check for latest Powershell module
# https://www.powershellgallery.com/packages/ArcHci/0.2.10

get-command -module archci

# Check the status of AsHCI
Get-AzureStackHCI

# !!! 
# NO AUTO CONFIG CONTAINER - THROUGH AKS-HCI CONFIG
# Set-AksHciConfig -vnet $vnet -imageDir "C:\ClusterStorage\Volume04-AKS-HCI\AKS-HCI\Images" -workingDir "C:\ClusterStorage\Volume04-AKS-HCI\AKS-HCI\WorkingDir" -cloudConfigLocation "C:\ClusterStorage\Volume04-AKS-HCI\AKS-HCI\Config" -cloudservicecidr "192.168.52.165/23" -kvaname "akshcihcl-management-cluster-1" -createAutoConfigContainers $false -Verbose 


# Variable for Deployment
# Prep for Arc HCI Applicance
$resource_group="ArcHCIRB-rg"
$subscription="b3bf1377-93c2-49be-a5cc-d09f00a519a4"
$Location="westeurope"
$customloc_name="AsHCI03-HybridCloudLab"

$VswitchName="ComputeSwitch"
$ControlPlaneIP="192.168.52.166"
$VMIP_1="192.168.52.167" #(required only for static IP configurations)   
$VMIP_2="192.168.52.168" #(required only for static IP configurations)   
$DNSServers="192.168.53.246" #For example: @("192.168.250.250","192.168.250.255") for a list of DNS servers. Or "192.168.250.250" for a single DNS server" (required only for static IP configurations)
$IPAddressPrefix="192.168.52.0/23" #(required only for static IP configurations)
$Gateway="192.168.53.254" #(required only for static IP configurations)
$CloudServiceIP="192.168.52.202" #(required only for static IP configurations)
$csv_path = "C:\ClusterStorage\Volume03-ArcBridge"
$vnetName = "hci03rb-vnet"
$resource_name= ((Get-AzureStackHci).AzureResourceName) + "-arcbridge"
mkdir $csv_path\ResourceBridge
# Enable VM Extension to the applicance
$hciClusterId= (Get-AzureStackHci).AzureResourceUri

# Login on both nodes
az login --use-device-code

# Prep Azure
# Resource Group with Contributor role
# Check for Azure Resource Provider
# Check for latest updates on Azure CLI & Extensions

# START DEPLOYMENT
New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vswitchName $vswitchName -cloudFqdn $CloudServiceIP -vnetName $vnetName

# Validation
az arcappliance validate hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml

# Prepare the Arc Appliance
az arcappliance prepare hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml

# Deploy Arc Appliance --> deploy VM on HCI/Hyper-V, check with Hyper-V Manager or WAC
az arcappliance deploy hci --config-file  $csv_path\ResourceBridge\hci-appliance.yaml --outfile $env:USERPROFILE\.kube\config

# Create Arc Appliance
az arcappliance create hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --kubeconfig $env:USERPROFILE\.kube\config

# Takes up to 5 Min ... then it is in Running state
# Check for running appliance
az arcappliance show --resource-group $resource_group --name $resource_name

# # Enable VM Extension to the applicance
az k8s-extension create --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --extension-type Microsoft.AZStackHCI.Operator --scope cluster --release-namespace helm-operator2 --configuration-settings Microsoft.CustomLocation.ServiceAccount=hci-vmoperator --configuration-protected-settings-file $csv_path\ResourceBridge\hci-config.json --configuration-settings HCIClusterID=$hciClusterId --auto-upgrade true

# Check
az k8s-extension show --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator

# Create custom location
az customlocation create --resource-group $resource_group --name $customloc_name --cluster-extension-ids "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name/providers/Microsoft.KubernetesConfiguration/extensions/hci-vmoperator" --namespace hci-vmoperator --host-resource-id "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name" --location $Location

# DONE

# Prep for VM Deployment
# https://docs.microsoft.com/en-us/cli/azure/azurestackhci?view=azure-cli-latest
# First add network
$vnetName="ComputeSwitch"
az azurestackhci virtualnetwork create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --network-type "Transparent" --name $vnetName

# Second add VM Image as Gallery item
$galleryImageName="WS22-DC-20220706"
$galleryImageSourcePath="C:\ClusterStorage\Volume02-Install\RB-IMAGES\WS22-DC-20220706.vhdx"
$osType="Windows"
az azurestackhci galleryimage create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --image-path $galleryImageSourcePath --name $galleryImageName --os-type $osType
# Takes up to 5 Min ... then it is visible

# Ready for Deploy VM from Azure Portal
