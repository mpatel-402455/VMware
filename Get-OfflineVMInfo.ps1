<#
.SYNOPSIS                                                                     
    Get Offline VM servers list.
.DESCRIPTION                                                                  
    Get Offline VM Servers list with details.                                     
.NOTES                                                                        
    File Name      : Get-OfflineVMInfo.ps1                                
    Author         : https://github.com/mpatel-402455                
    Script Version : 1.0                                                      
    Last Modified  : September 14, 2016                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                            
    
#>

#Import-Module -Name VMware.VimAutomation.Core

$date = Get-Date -UFormat %Y-%m-%d-%H%M%S
$date

$VMs = ((Get-VM | Where-Object {$_.PowerState -eq "PoweredOff"} ) | Select-Object -Property Name)

$DatacenterName = (Get-Datacenter).name

Write-Host ""$VMs.Count" PoweredOff VMs found in "$DatacenterName" " -ForegroundColor Cyan



foreach ($vm in (Get-VM -Name $VMs.Name)) 
    {  
    $vm.name
  
     $Props = @{
                'VMName'=$vm.Name;  
                'PowerState'= $vm.PowerState;  
                'vCPU'= $vm.NumCpu;  
                'RAM(GB)'= $vm.MemoryGB;  
                'Total-HDD(GB)'= $vm.ProvisionedSpaceGB -as [int];  
                'HDDs(GB)'= ($vm | get-harddisk | select-object -ExpandProperty CapacityGB) -join " + "  
                'ProvisionedSpaceGB'= ($vm |Select-Object -Property Name,@{Label='ProvisionedSpaceGB'; EXPRESSION={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}).ProvisionedSpaceGB
                'UsedSpaceGB'= ($vm |Select-Object -Property Name,@{Label='UsedSpaceGB'; EXPRESSION={"{0:N2}" -f ($_.UsedSpaceGB)}}).UsedSpaceGB
                'Datastore'= (Get-Datastore -vm $vm) -split ", " -join ", ";  
                'Real-OS'= $vm.guest.OSFullName;  
                'Setting-OS' = $VM.ExtensionData.summary.config.guestfullname;  
                'EsxiHost'= $vm.VMHost;  
                #'vCenter Server' = ($vm).ExtensionData.Client.ServiceUrl.Split('/')[2].trimend(":443")  
                'Folder'= $vm.folder; 
                'MacAddress' = ($vm | Get-NetworkAdapter).MacAddress -join ", ";  
                'DataCenter' = $vm | Get-Datacenter;
                'PortGroup' = ($vm | Get-NetworkAdapter).NetworkName -join ", ";
                'Notes'=$vm.Notes; #<<<<<<

               }  
     $obj = New-Object -TypeName PSObject -Property $Props  
     Write-Output $obj `
        | Select-Object -Property 'VMName', 'Real-OS', 'vCPU', 'RAM(GB)', 'Total-HDD(GB)' ,'HDDs(GB)', 'ProvisionedSpaceGB','UsedSpaceGB','Datastore', 'PowerState', 'Setting-OS', 'EsxiHost', 'vCenter Server', 'Folder', 'MacAddress', 'DataCenter', 'PortGroup', 'Notes' `
        | Export-Csv -Path "D:\MyScripts\Output-Files\$DatacenterName-OfflineVM_Serves_info-$date.csv" -Append
  
   } 

