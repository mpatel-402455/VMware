<#
.SYNOPSIS                                                                     
    Get VM servers details. 
.DESCRIPTION                                                                  
    Get VM Servers list with details. Use only for inventory purpose for Peter.                                     
.NOTES                                                                        
    File Name      : Get-VMDetailInfo-v3.ps1                                
    Author         : https://github.com/mpatel-402455             
    Script Version : 3.0                                                      
    Last Modified  : Feb 21, 2017                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                        
    
#>

 #Add-PSSnapin vmware.vimautomation.core

 $date = Get-Date -UFormat %Y-%m-%d-%H%M%S
 $date

 #$vms=(get-vm TORDEVMMS01,antivirus)

$VMs = (Get-VM)


foreach ($VM in (Get-VM -Name $VMs.Name)) 
    {  
        #$VMOwner = ($VM | Get-Annotation -CustomAttribute Owner).value
        $Props = @{
                    'Asset ID / Tag'="NA";
                    'Name'=$VM.Name;     #VMName = "Name" in excel
                    'Description'= if ($vm.Notes -ne "$null"){$vm.Notes}else{"NA"}; #NOTES = Description field in Excel
                    'Type'="NA";
                    'Physical/Virtual'="Virtual";
                    'Class'="NA";
                    'Vendor'="VMWare";
                    'Model'="NA";
                    'Serial No'="NA";
                    'License No'="NA";
                    'Service Tag'="NA";
                    'MAC' = ($VM | Get-NetworkAdapter).MacAddress -join ", "; #MacAddress= "MAC" field in excel
                    'IP'= if (($VM.Guest.IPAddress[0]) -eq $null){"NA"}else{$VM.Guest.IPAddress[0]}  #$VM.Guest.IPAddress[0]; #'IP Address'= "IP" field in excel
                    'URL'="NA";
                    'State'= $VM.PowerState;    #'PowerState' ="Stage" field in excel
                    'OS' = $VM.ExtensionData.summary.config.guestfullname; #'Setting-OS'="OS" in excel
                    'OS Ver'= if (($VM.guest.OSFullName) -eq $null){"NA"}else{$VM.guest.OSFullName}                     #$VM.guest.OSFullName;  #'Real-OS'="OS Ver" in excel
                    'Firmware'="NA";
                    'Processor'= $VM.NumCpu ##vCPU = "Processor" field in Excel  <<<<<<<<<<<<<<<<<<<<<<<<<<
                    'Memory'= $VM.MemoryGB;  #RAM(GB)="Memory" field in excel
                    'Storage'= (($VM |Select-Object -Property Name,@{Label='ProvisionedSpaceGB'; EXPRESSION={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}).ProvisionedSpaceGB)+"GB" #ProvisionedSpaceGB="Storage" field in excel <<<<<<
                    'Primary User'="NA";
                    'Owner'="NA";
                    'Hypervisor'="VMware";
                    'Host Cluster'= ($VM | Select-Object -Property @{Name='Cluster';Expression={$_.VMHost.Parent}}).cluster;    #'ClusterName'= "Host Cluster" field in Excel
                    'Template'="NA"
                    'Location' = $VM | Get-Datacenter;    #'DataCenter'="Location" field in Excel
                    'Site'= if (($vm | Get-Datacenter).name -eq "Dev Enviroment"){"LAB (105 Moatfield Drive, Suite 1100, Toronto, ON M3B0A2)"}elseif(($vm | Get-Datacenter).name -eq "MCC"){"MCC (1320 Denison St, Markham, ON, L3R4K6)"}elseif(($vm | Get-Datacenter).name -eq "SCC"){"SCC (1855 Minnesota Court, Mississauga, ON, L5N1K7"}elseif(($vm | Get-Datacenter).name -eq "$null"){"NA"};
                    'Backup Strategy'="Veeam";
                    'Purchase'="NA";
                    'End of Support Date'="NA";
                    'End of Warranty Date'="NA";
                    'Source'=($global:DefaultVIServer).name;                   
                  }  
        $obj = New-Object -TypeName PSObject -Property $Props  
        Write-Output $obj `
        | Select-Object -Property 'Asset ID / Tag','Name', 'Description', 'Type','Physical/Virtual','Class','Vendor','Model','Serial No','License No','Service Tag','MAC','IP','URL','State','OS','OS Ver','Firmware','Processor','Memory','Storage','Primary User','Owner','Hypervisor','Host Cluster','Template','Location','Site','Backup Strategy','Purchase','End of Support Date','End of Warranty Date','Source'`
        | Export-Csv -Path "D:\MyScripts\Output-Files\VM_Serves_Inventory-v3-$date.csv" -Append
  
    }