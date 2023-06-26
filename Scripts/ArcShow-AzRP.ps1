###############################################################################
#                         
# -----------------------------------------------------------------------------
# Developer.......: Alexander Ortha (https://www.linkedin.com/in/alexanderortha/)
# Repo............: https://github.com/alexor-ms/AzureArcShow                               
#                 
#                     
# -----------------------------------------------------------------------------
# Summary.........: This script helps check & enable Azure Resource Provider .... It is just a starter and some manual
#                   stuff needs to be done.
#                   Please execute script step-by-step as there is no
#                   error handling yet.
# -----------------------------------------------------------------------------
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
###############################################################################
###############################################################################

# https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types

# Login
az login --use-device-code

# Select Azure subscription
$subscription = XYZ
az account set --subscription $subscription

# Check for Resource Providers
az provider list --query "[].{Provider:namespace, Status:registrationState}" --out table

# Register Azure Resource Providers
az provider register --namespace Microsoft.Kubernetes --wait
az provider register -n Microsoft.KubernetesConfiguration --wait
az provider register -n Microsoft.ExtendedLocation --wait
az provider register -n Microsoft.ResourceConnector --wait
az provider register -n Microsoft.AzureStackHCI --wait
az provider register -n Microsoft.HybridConnectivity --wait
az provider register -n Microsoft.Web --wait
az provider register -n Microsoft.ScVmm --wait
az provider register -n Microsoft.VMware --wait
az provider register -n Microsoft.ConnectedVMwarevSphere --wait
az provider register -n Microsoft.App --wait
az provider register -n Microsoft.AzureArcData --wait
az provider register -n Microsoft.ContainerInstance --wait
az provider register -n Microsoft.ContainerService --wait
az provider register -n Microsoft.ContainerRegistry --wait
az provider register -n Microsoft.Automanage --wait





