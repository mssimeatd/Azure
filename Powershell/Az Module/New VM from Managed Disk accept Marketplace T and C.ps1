$SubscriptionId = "65c959c3-fcac-4ebc-966b-98754151cef0"
$ResourceGroupName = "RG-GIS-PROD-ZAN"
$VMName = “wcg-gis-ges01”
$NICName = Get-azNetworkInterface -Name "wcg-gis-ges01-nic" -ResourceGroupName $ResourceGroupName
$VNetName = "VNET-WCG-PROD-GIS-asr"
$subnetName = "default"
$Location = "South Africa North"
$osDisk = "wcg-gis-ges01_OsDisk_1_b8a2b0ccbfee4236b7ff35d092057783"
$availabilitySet = Get-azAvailabilitySet -ResourceGroupName $resourcegroupname -AvailabilitySetName "GESAvailabilitySet-Server"
$addressPrefix = "10.1.161.0/25"
$PlanName = "byol-1061"
$PlanProduct = "arcgis-enterprise-106"
$PlanPublisher = "esri"

# Select subscription
Set-azContext -Subscription $SubscriptionId

# Get the managed OS disk
$ManagedDisk = Get-azDisk -ResourceGroupName $ResourceGroupName -DiskName $osDisk
 
 
# Accept licence terms for the publisher plan
Get-azMarketplaceTerms -Publisher $PlanPublisher -Product $PlanProduct -Name $PlanName | Set-azMarketplaceTerms -Accept
 
 
# Create the virtual machine
$newVM = New-azVMConfig -VMName $VMName -VMSize Standard_D5_v2 -AvailabilitySetId $availabilitySet.Id
$newVM = Set-azVMOSDisk -VM $newVM -ManagedDiskId $ManagedDisk.Id -CreateOption Attach -Windows
$newVM = Add-azVMNetworkInterface -VM $newVM -Id $NICName.Id
$newVM.Plan = New-Object -TypeName 'Microsoft.Azure.Management.Compute.Models.Plan'
$newVM.Plan.Name = $PlanName
$newVM.Plan.Product = $PlanProduct
$newVM.Plan.Publisher = $PlanPublisher
New-azVM -VM $newVM -ResourceGroupName $ResourceGroupName -Location $Location
