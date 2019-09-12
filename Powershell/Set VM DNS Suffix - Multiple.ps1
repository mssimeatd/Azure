# Add multiple DNS Suffixes (append)
$DNSsuffixes =  “Contoso.com”,”Child.Contoso.com”
Invoke-Wmimethod -Class win32_networkadapterconfiguration -Name setDNSSuffixSearchOrder -ArgumentList @($DNSSuffixes),$null