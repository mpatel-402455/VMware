 <#
.SYNOPSIS                                                                     
    Get VM servers details.
.DESCRIPTION                                                                  
    Get VM Servers list with details.                                     
.NOTES                                                                        
    File Name      : Get-VMDetailInfo-v2.ps1                                
    Author         : https://github.com/mpatel-402455                 
    Script Version : 1.0                                                      
    Last Modified  : September 26, 2016                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                            
    
#>
 

 #Add-PSSnapin vmware.vimautomation.core

 $date = Get-Date -UFormat %Y-%m-%d-%H%M%S
 $date

#$VMs= @("tordevelk01","TORORAREP04","tordevdru01")
$VMs = (Import-Csv -Path C:\MyScripts\In-Put-Files\DR-ServerList2016.csv)

foreach ($vm in (Get-VM -Name $VMs.HostName)) 
        {  
#foreach ($vm in (Get-VM -Name $VMs)) {      
     #$VM
     $props = @{'VMName'=$vm.Name;  
           'IP Address'= $vm.Guest.IPAddress[0]; #$VM.ExtensionData.Summary.Guest.IpAddress  
           'PowerState'= $vm.PowerState;  
           'Domain Name'= ($vm.ExtensionData.Guest.Hostname -split '\.')[1,2] -join '.';            
           #'vCPU'= $vm.NumCpu;  
           #'RAM(GB)'= $vm.MemoryGB;  
           #'Total-HDD(GB)'= $vm.ProvisionedSpaceGB -as [int];  
           #'HDDs(GB)'= ($vm | get-harddisk | select-object -ExpandProperty CapacityGB) -join " + "     
           #'ProvisionedSpaceGB'= ($vm |Select-Object -Property Name,@{Label='ProvisionedSpaceGB'; EXPRESSION={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}).ProvisionedSpaceGB
           #'UsedSpaceGB'= ($vm |Select-Object -Property Name,@{Label='UsedSpaceGB'; EXPRESSION={"{0:N2}" -f ($_.UsedSpaceGB)}}).UsedSpaceGB                  
           #'Datastore'= (Get-Datastore -vm $vm) -split ", " -join ", ";  
           #'Partition/Size' = Get-InternalHDD -VMName $vm.Name  
           'Real-OS'= $vm.guest.OSFullName;  
           #'Setting-OS' = $VM.ExtensionData.summary.config.guestfullname;  
           'EsxiHost'= $vm.VMHost;  
           'vCenter Server' = ($vm).ExtensionData.Client.ServiceUrl.Split('/')[2].trimend(":443")  
           #'Hardware Version'= $vm.Version;  
           'Folder'= $vm.folder;  
           #'MacAddress' = ($vm | Get-NetworkAdapter).MacAddress -join ", ";  
           #'VMX' = $vm.ExtensionData.config.files.VMpathname;  
           #Works 'VMDK' = ($vm | Get-HardDisk).filename -join ", ";  
           #'VMTools Status' = $vm.ExtensionData.Guest.ToolsStatus;  
           #'VMTools Version' = $vm.ExtensionData.Guest.ToolsVersion;  
           #'VMTools Version Status' = $vm.ExtensionData.Guest.ToolsVersionStatus;  
           #'VMTools Running Status' = $vm.ExtensionData.Guest.ToolsRunningStatus;  
           #'SnapShots' = ($vm | get-snapshot).count;  
           'DataCenter' = $vm | Get-Datacenter;  
           #'PortGroup' = ($vm | Get-NetworkAdapter).NetworkName -join ", ";
           'Notes'=$vm.Notes;  
           }  
     $obj = New-Object -TypeName PSObject -Property $Props  
     Write-Output $obj `
        | select-object -Property 'VMName', 'IP Address', 'Domain Name', 'Real-OS', 'vCPU', 'RAM(GB)', 'Total-HDD(GB)' ,'HDDs(GB)','ProvisionedSpaceGB','UsedSpaceGB', 'Datastore', 'Partition/Size', 'Hardware Version', 'PowerState', 'Setting-OS', 'EsxiHost', 'vCenter Server', 'Folder', 'MacAddress', 'VMX', 'VMDK', 'VMTools Status', 'VMTools Version', 'VMTools Version Status', 'VMTools Running Status', 'SnapShots', 'DataCenter', 'vNic', 'PortGroup', 'RDMs', 'Notes' `
        | Export-Csv -Path "D:\MyScripts\Output-Files\VM_Serves_info-$date.csv" -Append
  
   } 