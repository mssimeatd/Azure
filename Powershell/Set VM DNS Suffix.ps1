#Set VM DNS Suffix

$networkConfig = Get-WmiObject Win32_NetworkAdapterConfiguration -filter "ipenabled = 'true'"
$networkConfig.SetDnsDomain("clients.ad.company.com")
$networkConfig.SetDynamicDNSRegistration($true,$true)
ipconfig /registerdns

# Add multiple DNS Suffixes (append)
$DNSsuffixes =  “Contoso.com”,”Child.Contoso.com”
Invoke-Wmimethod -Class win32_networkadapterconfiguration -Name setDNSSuffixSearchOrder -ArgumentList @($DNSSuffixes),$null 

# Add just a single DNS suffix (overwrite)
Invoke-WmiMethod -Class win32_networkadapterconfiguration -Name setDNSSuffixSearchOrder -Argument "contoso.com"