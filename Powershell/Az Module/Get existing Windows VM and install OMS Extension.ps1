# Get existing Windows VM and install OMS Extension
Login-azAccount #login using account associated with Azure tenant. 

Get-azSubscription -SubscriptionId "<your subscription ID>" | Select-azSubscription      
$VMresourcegroup = "<your Resource GRoup>"
$vmName = "<your VM name>"
$vm = Get-azVM -ResourceGroupName $VMresourcegroup -Name $vmName
$location = $vm.location

$ExtensionName = 'MicrosoftMonitoringAgent' # NOTE: for Linux VM use 'OmsAgentForLinux'

# Enter Log Analytic specific details. WorkspaceID and Key
$workSpaceID = '<your workspaceID>'		# Copy from OMS Portal
$workSpaceKey = '<your Log Analytics Workspace Key>' # Copy from Log Analytics Workspace 
Set-azVMExtension -ResourceGroupName $VMresourcegroup -VMName $VMname -Name $ExtensionName -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType $ExtensionName -TypeHandlerVersion '1.0' -Location $location -SettingString "{'workspaceId':'$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey'}"
