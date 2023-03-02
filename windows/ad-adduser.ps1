Add-PSSnapin Quest.ActiveRoles.ADManagement
#the first parameter should only be enaled if running this directly from the powershell.  not when using gui.
#random password generator

$ABC="A","B","C","D","E","F","G","H","I","J","K","L","M","N","O"
$ab="a","b","c","d","e","f","g","h","i","j","k","l","m","n","o"
$Num="1","2","3","4","5","6","7","8","9","0"

Function GET-Temppassword() {
Param(
[int]$length=9,
[string[]]$sourcedata
)
For ($loop=1; $loop -le $length; $loop++) {
            $TempPassword+=($sourcedata | GET-RANDOM)
            }
return $TempPassword
}



For ($loop=1; $loop -le $length; $loop++) {

            $TempPassword+=($sourcedata | GET-RANDOM)

            }

return $TempPassword

}

[string]$description=Read-Host "What company does this user work for?"
[string]$company=$description
[string]$givenname=Read-Host "The users's First Name"
[string]$sn=Read-Host "and their Last Name"
[string]$name= $givenname+ ' '+$sn
[string]$mail=Read-Host "Enter their e-mail address, this will also be their user name"
[string]$userPrincipalName=$mail
[string]$ftp="CN=FTP-ldap,OU=corp-FTP,DC=corp,DC=aws"
[string]$cloud="CN=corp Cloud,OU=corp Groups,DC=corp,DC=aws"

#next, reduce samaccountname to 20 characters, as that is an LDAP limit
[string]$UserNamePrepared= ("$($givenname[0])$($sn -replace '\s','')" -replace '^(.{1,20}).*$','$1').ToLower()
[string]$randomNumber = Get-Random -Maximum 99 -Minimum 1
[string]$UserName=$UserNamePrepared+$randomNumber
[string]$samaccountname=$UserName

$ascii=$NULL;
For ($a=48;$a -le 122;$a++) {$ascii+=,[char][byte]$a }
$userpassword = GET-Temppassword -length 9 -sourcedata ($ABC+$Num+$ab)
#[string]$userpassword=Read-Host "Desired password(must be complex, ie: One2345!"

new-qaduser -mail $mail -name $name -givenname $givenname -sn $sn -ParentContainer 'OU=CUST,OU=corp,DC=corp,DC=aws' -description $description -company $company -samAccountName $UserName -userPrincipalName $userprincipalname -UserPassword $userpassword
Add-QADGroupMember -Identity $ftp -Member $samaccountname

Write-Host ""
Write-Host ""
Write-Host "***************** SUMMARY *****************"
Write-Host "New User Created as:"
Write-Output $name
Write-Output $mail
Write-Output $userpassword
$userpassword | CLIP
Write-Host "Password saved to clipboard."
Write-Host "*****************   END   *****************"
Write-Host ""
Write-Host "Writing summary to log file."

#create a file with the credentials.
"Name: $name, E-Mail: $mail, Password: $userpassword" | out-file -filepath D:\karlfiles\corp-karlfiles\userCreationLogs\$samaccountname.txt -append -width 200


#Notify in Slack
$notificationPayload = @{
    text="$name ($company), corp Support and FTP accounts have been established.  The credentials for accessing our systems are your email address ( $mail ) and your temporary password ( $userpassword ).  The welcome email contains additional details about managing your identity and accessing our systems.";
    username="nameduser";
    #icon_url="http://thespinningmule.com/wp-content/uploads/2014/08/metro-powershell-logo.png"
}
Invoke-RestMethod -Uri "https://hooks.slack.com/services/HIDDEN" -Method Post -Body (ConvertTo-Json $notificationPayload)

#notify in PipeDrive
#$notificationPayloadPipeDrive = @{
#   owner_id="375889"
#   org_id="5725"
#   visible_to="3"
#   name="$name"
#   email="$mail"
#}
#$jsonPipeDrive=$notificationPayloadPipeDrive | ConvertTo-Json
#Invoke-RestMethod 'https://api.pipedrive.com/v1/persons?api_token=HIDDENh' -Method Post -Body $jsonPipeDrive -ContentType 'application/json'



Write-Host "Completed. This window will remain open for 10 seconds.  Rerun the script to add another user."
Start-Sleep 10
