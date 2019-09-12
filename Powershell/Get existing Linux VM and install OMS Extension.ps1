# Get existing Linux VM and install OMS Extension
Login-azAccount #login using account associated with Azure tenant. 

Get-azSubscription -SubscriptionId "<your subscription ID>" | Select-azSubscription      
$VMresourcegroup = "<your Resource GRoup>"
$vmName = "<your VM name>"
$vm = Get-azVM -ResourceGroupName $VMresourcegroup -Name $vmName
$location = $vm.location

$ExtensionName = 'OmsAgentForLinux' # NOTE: for Windows VM use 'MicrosoftMonitoringAgent'

# Enter OMS specific details. WorkspaceID and Key
$workSpaceID = '<your workspaceID>'		# Copy from OMS Portal
$workSpaceKey = '<your OMS Key>'		# Copy from OMS portal 
Set-azVMExtension -ResourceGroupName $VMresourcegroup -VMName $VMname -Name $ExtensionName -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType $ExtensionName -TypeHandlerVersion '1.0' -Location $location -SettingString "{'workspaceId':'$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey'}"
