#this will add a username@corpcloud.com to all users

#Clear all proxy addresses - USE CAUTION
#Get-ADUser -Filter * -SearchBase 'OU=CORP,OU=corp,DC=corp,DC=aws' -Properties proxyaddresses | Foreach {Set-AdUser -Identity $_ -Clear ProxyAddresses}

#Set specific address.  Here is samaccountname and then @corpcloud.com
Get-ADUser -Filter * -SearchBase 'OU=CORP,OU=corp,DC=corp,DC=aws' -Properties proxyaddresses | Foreach {Set-ADUser -identity $_ -Add @{'ProxyAddresses'=@(("{0}@{1}"-f $_.samaccountname, 'corpcloud.com'))} }
