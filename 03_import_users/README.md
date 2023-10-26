# 03 - Importing users via Powershell

Note: I used a custom csv file of users to import. If you are generating your own list, you will need to modify the ```import_users.ps1``` script to reflect the fields and information

1. Using the PSRemote Session, copy ```ad_users.csv``` and ```import_users.ps1``` to your Server from your management pc

2. Run the .ps1 script on the Server to create groups, users, and add users to groups