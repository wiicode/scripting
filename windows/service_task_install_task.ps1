#this installs our task
#requires environmental variables to be set properly on our system.

$pass=$env:admin
Register-ScheduledTask -Xml (get-content 'c:\ops\scripts\service_tasks.xml' | out-string) -TaskName "ServiceTasks" -User corp\admin -Password $pass -Force
