# 02 - Join Workstation to AD Server

1. Change dns settings of workstation to point to AD Server
```shell
Get-NetIPAddress
```
to get the Interface Index of the network adapter
```shell
Set-DNSClientServerAddress -InterfaceIndex Index_Number -ServerAddresses IP_of_Windows_Server
```
to set the DNS to the Windows Server

2. Join the workstation to the Domain via Powershell
```shell
add-computer -domainname xyz.com -Credential xyz\Administrator -restart -force
```

Note: Be sure to snapshot your VMs as you progress