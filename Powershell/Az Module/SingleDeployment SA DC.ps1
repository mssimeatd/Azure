# Add updated enpoints
$env = Add-AzEnvironment -Name SouthAfricaNorth `
    -PublishSettingsFileUrl 'http://go.microsoft.com/fwlink/?LinkID=301775' `
    -ServiceManagementUrl 'https://management.core.windows.net/' `
    -ManagementPortalUrl 'http://go.microsoft.com/fwlink/?LinkId=254433' `
    -ActiveDirectoryAuthority 'https://login.microsoftonline.com/' `
    -ActiveDirectoryServiceEndpointResourceId 'https://management.core.windows.net/' `
    -ResourceManagerEndpoint 'https://southafricanorth.management.azure.com' `
    -GalleryEndpoint 'https://gallery.azure.com/' `
    -GraphUrl 'https://graph.windows.net/' `
    -GraphEndpointResourceId 'https://graph.windows.net/'
Login-AzAccount -Environment $env

# Re-register Service Providers
Register-AzResourceProvider -ProviderNamespace Microsoft.ApiManagement
Register-AzResourceProvider -ProviderNamespace Microsoft.ClassicCompute
Register-AzResourceProvider -ProviderNamespace Microsoft.ClassicStorage
Register-AzResourceProvider -ProviderNamespace Microsoft.ClassicNetwork
Register-AzResourceProvider -ProviderNamespace Microsoft.Batch
Register-AzResourceProvider -ProviderNamespace Microsoft.Cache
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.DocumentDB
Register-AzResourceProvider -ProviderNamespace Microsoft.EventHub
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault
Register-AzResourceProvider -ProviderNamespace Microsoft.Network
Register-AzResourceProvider -ProviderNamespace Microsoft.RecoveryServices
Register-AzResourceProvider -ProviderNamespace Microsoft.Relay
Register-AzResourceProvider -ProviderNamespace Microsoft.Resources
Register-AzResourceProvider -ProviderNamespace Microsoft.ServiceBus
Register-AzResourceProvider -ProviderNamespace Microsoft.ServiceFabric
Register-AzResourceProvider -ProviderNamespace Microsoft.Sql
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage
Register-AzResourceProvider -ProviderNamespace Microsoft.Web

# Select the Subscription ID for the deployment
$SubID = "Your Subcription ID"
Select-AzSubscription -SubscriptionId $SubID
$rgname = "Your Resource Group name"
$loc = "Your Deployment Location”
New-azResourceGroup -Name $rgname -Location $loc -Force;
# VM Profile & Hardware
$vmsize = 'Standard_A1_v2';
$vmname = 'vm' + $rgname;
$p = New-azVMConfig -VMName $vmname -VMSize $vmsize;
# NRP
$subnet = New-azVirtualNetworkSubnetConfig -Name ('subnet' + $rgname) -AddressPrefix "10.0.0.0/24";
$vnet = New-azVirtualNetwork -Force -Name ('vnet' + $rgname) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet;
$vnet = Get-azVirtualNetwork -Name ('vnet' + $rgname) -ResourceGroupName $rgname;
$subnetId = $vnet.Subnets[0].Id;
$pubip = New-azPublicIpAddress -Force -Name ('pubip' + $rgname) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ('pubip' + $rgname);
$pubip = Get-azPublicIpAddress -Name ('pubip' + $rgname) -ResourceGroupName $rgname;
$pubipId = $pubip.Id;
$nic = New-azNetworkInterface -Force -Name ('nic' + $rgname) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId -PublicIpAddressId $pubip.Id;
$nic = Get-azNetworkInterface -Name ('nic' + $rgname) -ResourceGroupName $rgname;
$nicId = $nic.Id;
$p = Add-azVMNetworkInterface -VM $p -Id $nicId;
# Adding the same Nic but not set it Primary
$p = Add-azVMNetworkInterface -VM $p -Id $nicId -Primary;
# Storage Account (SA)
$stoname = 'storpla' + $rgname;
$stotype = 'Standard_GRS';
New-azStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype;
$stoaccount = Get-azStorageAccount -ResourceGroupName $rgname -Name $stoname;
# OS & Image
$user = "Foo12";
$password = "p@ssqw0rd";
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force;
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);
$computerName = 'test';
$p = Set-azVMOperatingSystem -VM $p -Windows -ComputerName $computerName -Credential $cred -ProvisionVMAgent;
$imgRef = Get-azVMImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Sku "2012-R2-Datacenter" -Location $loc
$p = ($imgRef[0] | Set-azVMSourceImage -VM $p);
# Virtual Machine
New-azVM -ResourceGroupName $rgname -Location $loc -VM $p;
# Get VM
$vm1 = Get-azVM -Name $vmname -ResourceGroupName $rgname -DisplayHint Expand;
