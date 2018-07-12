<#
.SYNOPSIS                                                                     
    Get VM servers with Snapshots                                             
.DESCRIPTION                                                                  
    Get VM with Snapshots and its details.                                     
.NOTES                                                                        
    File Name      : Get-VM-with-Snapshot.ps1                                 
    Author         : https://github.com/mpatel-402455                
    Script Version : 1.0                                                      
    Last Modified  : January 31, 2017                                          
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                            
    
#>

$date = Get-Date -UFormat %Y-%m-%d-%H%M%S
$date


$SizeMB = @{LABEL='Size(MB)';EXPRESSION={"{0:N2}" -f ($_.SizeMb)}}
$SizeGB = @{LABEL='Size(GB)';EXPRESSION={"{0:N2}" -f ($_.SizeGB)}}

$ServerS = (Import-Csv -Path D:\MyScripts\In-Put-Files\Check_Snapshot_VM-List.csv)

foreach ($VM in $ServerS)
    {
        #$vm.name
        Get-VM -Name $vm.Name | Get-Snapshot | Select-Object -Property VM,Name,Description,$SizeMB,$SizeGB,Created,PowerState,IsCurrent | Export-Csv -Path "D:\MyScripts\Output-Files\INC000000453388_VM_with_SnapShots_$date.csv" -Append

    } 