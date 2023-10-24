# 01 - Installing Domain Controller

1. Use 'sconfig' to :
    - Change the hostname
    - Change the IP address to static
    - Change the DNS setting to our IP address

2. Install Active Directory Windows Feature
```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```
```shell
import-Module ADDSDeployment
```
```shell
Install-ADDSForest
```

3. Reset DNS servers to IP address of Windows server
    - Use sconfig to reset DNS from loopback (127.0.0.1) to IP address of Windows server
