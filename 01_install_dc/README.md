# 01 - Installing Domain Controller

1. Use 'sconfig' to :
    - Change the hostname
    - Change the IP address to static
    - Change the DNS setting to our IP address

2. Install Active Directory Windows Feature
```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

