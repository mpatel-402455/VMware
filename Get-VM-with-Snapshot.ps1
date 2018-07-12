<#
.SYNOPSIS                                                                     
    Get VM servers with Snapshots                                             
.DESCRIPTION                                                                  
    Get VM with Snapshots and its details.                                     
.NOTES                                                                        
    File Name      : Get-VM-with-Snapshot.ps1                                 
    Author         : https://github.com/mpatel-402455                 
    Script Version : 1.0                                                      
    Last Modified  : April 27, 2016                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                            
    
#>

$date = Get-Date -UFormat %Y-%m-%d-%H%M%S
$date

 
$SizeMB = @{LABEL='Size(MB)';EXPRESSION={"{0:N2}" -f ($_.SizeMb)}}
$SizeGB = @{LABEL='Size(GB)';EXPRESSION={"{0:N2}" -f ($_.SizeGB)}}

#Get-Datastore -Name IT_SAS_Store01 | Get-VM | Get-Snapshot | Select-Object -Property VM,Name,$SizeMB,$SizeGB,Created,PowerState,IsCurrent

Get-VM | Get-Snapshot | Select-Object -Property VM,Name,$SizeMB,$SizeGB,Created,PowerState,IsCurrent | Export-Csv -Path "D:\MyScripts\Output-Files\Dev-QA_VM_with_SnapShots_$date.csv"

# Get-VApp -name "IAM 2.0 HA Dev" | Get-VM | Get-Snapshot | Select-Object -Property VM,Name,$SizeMB,$SizeGB,Created,PowerState,IsCurrent | Export-Csv -Path "D:\MyScripts\Output-Files\IAM-DEV_with_SnapShots_$date.csv"
# Get-VApp -name "IAM 2.0 HA TEST"| Get-VM | Get-Snapshot | Select-Object -Property VM,Name,$SizeMB,$SizeGB,Created,PowerState,IsCurrent | Export-Csv -Path "D:\MyScripts\Output-Files\IAM-Test_VM_with_SnapShots_$date.csv"
# Get-VApp -name "IAM HA 2.0 Staging" | Get-VM | Get-Snapshot | Select-Object -Property VM,Name,$SizeMB,$SizeGB,Created,PowerState,IsCurrent | Export-Csv -Path "D:\MyScripts\Output-Files\IAM-Staging_VM_with_SnapShots_$date.csv"


