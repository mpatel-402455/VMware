<#
.SYNOPSIS                                                                     
    Get ESX Host UUID                                             
.DESCRIPTION                                                                  
    Get ESX Host UUID.                                     
.NOTES                                                                        
    File Name      : Get-VM-with-Snapshot.ps1                                 
    Author         : https://github.com/mpatel-402455                
    Script Version : 1.0                                                      
    Last Modified  : April 01, 2016                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                            
    
#>


$VMHosts = Get-VMHost

foreach ($VMHost in $VMHosts)
    {
      $UUID = (Get-VMHost -Name $VMHost.Name | Get-View | Select-Object -Property Name, @{Name="UUID";Expression={$_.Hardware.SystemInfo.uuid}})
       $UUID | Export-Csv -Path D:\MyScripts\Output-Files\VMHost_UUID-list.csv -Append
    }   