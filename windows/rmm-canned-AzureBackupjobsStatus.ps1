Import-Module Azure 

$cred = Get-Credential

Login-AzureRmAccount -Credential $cred


$Subscriptions = Get-AzureRmsubscription

<if ($SubscriptionName)
{
    $Subscriptions = $Subscriptions | where { $_.SubscriptionName -EQ $SubscriptionName }
}
elseif ($SubscriptionId)
{
    $Subscriptions = $Subscriptions | where { $_.SubscriptionId -EQ $SubscriptionId }
}


$jobsAllArray = @()

$i=0

foreach ( $Subscription in $Subscriptions ) 

{

    $SubscriptionId = $Subscription.SubscriptionId

   Login-AzureRmAccount -Credential $cred -subscriptionid $SubscriptionId

    (Select-AzureSubscription -current -SubscriptionId $SubscriptionId)>0


   
 $i++
    
   Write-Progress -activity $subscription.SubscriptionName -PercentComplete ($i/$Subscriptions.Count*100)
    
 
    
    
	 $rcvaults=Get-AzureRmRecoveryServicesVault
	
    
	foreach ($rcvault in $rcvaults)
	{ 
      Write-Host $rcvault.Name
	   get-azurermrecoveryservicesvault -name $rcvault.Name | set-azurermrecoveryservicesvaultcontext ;
       $JobStatus=Get-AzureRmRecoveryServicesBackupJob -From (Get-Date).AddDays(-1).ToUniversalTime() |Select WorkloadName,Operation,Status,StartTime,EndTime;
     

        $jobsAllArray +=New-Object PSObject -Property @{`
            ServerName=$JobStatus.WorkloadName; `
            Operation=$JobStatus.Operation; `
            Status=$JobStatus.Status ;`
            StartTime=$JobStatus.StartTime;`
            EndTime=$JobStatus.EndTime; }
                   
	   
	  } 
    $CompletedJjobs= $jobsAllArray.Where({$_.Status -eq 'Completed'})
    $InprogressJobs= $jobsAllArray.Where({$_.Status -eq 'InProgress'})
	$FailedJobs= $jobsAllArray.Where({$_.Status -eq 'Failed'})
   

} 
Write-Host "No of jobs Completed" $CompletedJjobs.Count
Write-Host "No of jobs In Progress" $InprogressJobs.count
Write-Host "No of jobs Failed" $FailedJobs.Count
$jobsAllArray |Out-Gridview 


