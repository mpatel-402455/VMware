<#
.SYNOPSIS                                                                     
    Get VM servers details.
.DESCRIPTION                                                                  
    Get VM Servers list with details.                                     
.NOTES                                                                        
    File Name      : Get-VMDetailInfo-v2.ps1                                
    Author         : https://github.com/mpatel-402455                 
    Script Version : 2.0                                                      
    Last Modified  : October 19, 2016                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                         
    
#>

 #Add-PSSnapin vmware.vimautomation.core

 $date = Get-Date -UFormat %Y-%m-%d-%H%M%S
 $date

#$VMs= @("tordevelk01","TORORAREP04","tordevdru01")
#$VMs = (Import-Csv -Path C:\MyScripts\In-Put-Files\DR-ServerList2016.csv)

#$VMs = (Get-VirtualPortGroup -Name 229-QA-ADMIN, 231-QA-DMZ,232-QA-VIDEO,233-QA-DATA, 894-ORACLE-RAC | Get-VM)
#$vms = (Get-VMHost -Name 10.224.129.222 | Get-VM)
#$VMs = (Get-Cluster -Name "QATest cluster" | Get-VM)

$VMs = (Get-VM)

foreach ($VM in (Get-VM -Name $VMs.Name)) 
    {  
        $Props = @{
                    'VMName'=$VM.Name;  
                    'IP Address'= $VM.Guest.IPAddress[0]; #$VM.ExtensionData.Summary.Guest.IpAddress  
                    'PowerState'= $VM.PowerState;  
                    'Domain Name'= ($VM.ExtensionData.Guest.Hostname -split '\.')[1,2] -join '.';            
                    #'vCPU'= $VM.NumCpu;  
                    #'RAM(GB)'= $VM.MemoryGB;  
                    #'Total-HDD(GB)'= $VM.ProvisionedSpaceGB -as [int];  
                    #'HDDs(GB)'= ($VM | get-harddisk | select-object -ExpandProperty CapacityGB) -join " + "
                    #'ProvisionedSpaceGB'= ($VM |Select-Object -Property Name,@{Label='ProvisionedSpaceGB'; EXPRESSION={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}).ProvisionedSpaceGB
                    #'UsedSpaceGB'= ($VM |Select-Object -Property Name,@{Label='UsedSpaceGB'; EXPRESSION={"{0:N2}" -f ($_.UsedSpaceGB)}}).UsedSpaceGB            
                    #'Datastore'= (Get-Datastore -vm $VM) -split ", " -join ", ";  
                    #'Partition/Size' = Get-InternalHDD -VMName $VM.Name  
                    'Real-OS'= $VM.guest.OSFullName;  
                    'Setting-OS' = $VM.ExtensionData.summary.config.guestfullname;  
                    'EsxiHost'= $VM.VMHost;  
                    #'vCenter Server' = ($VM).ExtensionData.Client.ServiceUrl.Split('/')[2].trimend(":443")  
                    #'Hardware Version'= $VM.Version;  
                    'Folder'= $VM.folder;  
                    'MacAddress' = ($VM | Get-NetworkAdapter).MacAddress -join ", ";  
                    #'VMX' = $VM.ExtensionData.config.files.VMpathname;  
                    #Works 'VMDK' = ($VM | Get-HardDisk).filename -join ", ";  
                    # 'VMTools Status' = $VM.ExtensionData.Guest.ToolsStatus;  
                    #'VMTools Version' = $VM.ExtensionData.Guest.ToolsVersion;  
                    #'VMTools Version Status' = $VM.ExtensionData.Guest.ToolsVersionStatus;  
                    # 'VMTools Running Status' = $VM.ExtensionData.Guest.ToolsRunningStatus;  
                    #'SnapShots' = ($vm | get-snapshot).count;  
                    'DataCenter' = $VM | Get-Datacenter;  
                    'PortGroup' = ($VM | Get-NetworkAdapter).NetworkName -join ", ";  
                    'ClusterName' = ($VM | Select-Object -Property @{Name='Cluster';Expression={$_.VMHost.Parent}}).cluster;
                    'Notes'=$VM.Notes;
                  }  
        $obj = New-Object -TypeName PSObject -Property $Props  
        Write-Output $obj `
        | Select-Object -Property 'VMName', 'IP Address','PowerState','RAM(GB)','EsxiHost', 'Total-HDD(GB)' ,'HDDs(GB)', 'ProvisionedSpaceGB','UsedSpaceGB','Real-OS','Setting-OS','VMTools Status','VMTools Running Status','PortGroup','ClusterName','DataCenter','Notes'`
        | Export-Csv -Path "D:\MyScripts\Output-Files\VM_Serves_info-$date.csv" -Append
  
    } 
  
#| Select-Object -Property 'VMName', 'IP Address', 'Domain Name', 'Real-OS', 'vCPU', 'RAM(GB)', 'Total-HDD(GB)' ,'HDDs(GB)', 'ProvisionedSpaceGB','UsedSpaceGB', 'Datastore', 'Partition/Size', 'Hardware Version', 'PowerState', 'Setting-OS', 'EsxiHost', 'vCenter Server', 'Folder', 'MacAddress', 'VMX', 'VMDK', 'VMTools Status', 'VMTools Version', 'VMTools Version Status', 'VMTools Running Status', 'SnapShots', 'DataCenter', 'vNic', 'PortGroup', 'RDMs' ,'ClusterName', 'Notes'`