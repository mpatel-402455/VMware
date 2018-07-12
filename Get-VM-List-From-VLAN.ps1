  <#
.SYNOPSIS                                                                     
    Get VM, Name, IP and MAC address from specified VLANs.
.DESCRIPTION                                                                  
    Get VM Servers list with Name, IP and MAC address details.                                     
.NOTES                                                                        
    File Name      : Get-VM-List-From-VLAN.ps1                                
    Author         : https://github.com/mpatel-402455               
    Script Version : 1.0                                                      
    Last Modified  : September 3, 2016                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                             
    
#>
  
$date = Get-Date -UFormat %Y-%m-%d-%H%M%S
$date

$ExportFilePath = "D:\MyScripts\Output-Files\VM-List-From-VLAN-$date.csv"

$vms = Get-VirtualPortGroup -Name "229-QA-Admin","230-QA-APP","231-QA-DMZ","232-QA-VIDEO","233-QA-DATA" | Get-VM | Select-Object -Property Name


foreach ($vm in (Get-VM -Name $VMs.Name)) 
    {  
        $vm
        $props = @{'VMName'=$vm.Name;  
                   'IP Address'= $vm.Guest.IPAddress[0]; #$VM.ExtensionData.Summary.Guest.IpAddress  
                   'MacAddress' = ($vm | Get-NetworkAdapter).MacAddress -join ", ";  
                   'PortGroup' = ($vm | Get-NetworkAdapter).NetworkName -join ", ";  
                  }
                
     $obj = New-Object -TypeName PSObject -Property $Props  
     Write-Output $obj `
        | select-object -Property 'VMName', 'IP Address', 'MacAddress', 'PortGroup'`
        | Export-Csv -Path $ExportFilePath -Append
  
   } 

