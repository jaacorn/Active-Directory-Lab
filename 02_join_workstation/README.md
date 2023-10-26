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

# Extra

1. Setting up a 3rd "Management" pc that is not joined to the domain
2. Setting up PSRemote Session for easy managment of the Domain Controller from the Management PC
    - ```Start-Service WinRM```
    - ```set-item wsman:\localhost\Client\TrustedHosts -value IP_OF_SERVER```
    - ```New-PSSession -ComputerName IP_OF_SERVER -Credential (Get-Credential)```
    - ```Enter-PSSession ID_OF_SESSION```
    - Note: Create new variable to make life easy
        ```$dc = New-PSSession IP_OF_SERVER -Credential (Get-Credential)```
        To copy files to Server: ```Copy-Item .\file -ToSession $dc C:\Scripts```
        To enter Session: ```Enter-PSSession $dc```