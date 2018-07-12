<#
.SYNOPSIS                                                                     
    Get Offline VM servers list.
.DESCRIPTION                                                                  
    Get Offline VM Servers list with details.                                     
.NOTES                                                                        
    File Name      : Get-OfflineVMInfo.ps1                                
    Author         : https://github.com/mpatel-402455              
    Script Version : 1.0                                                      
    Last Modified  : March 17, 2016                                           
    Prerequisite   : PowerShell/PowerCLI/Module:VMware.VimAutomation.Cis.Core 
    Copyright      : https://github.com/mpatel-402455                                            
    
#>

#Import-Module -Name VMware.VimAutomation.Core

    $date = Get-Date -UFormat %Y-%m-%d-%H%M%S
    $date

Get-Datacenter -Name "Dev Enviroment" | Get-VM

#### Get Virtual Center To Connect to:

#$VCServerName = Read-Host "What is the Virtual Center name?"
#$VCServerName = "TORDEVVMC01"
#$ExportFilePath = Read-Host "Where do you want to export the data?"
$ExportFilePath = "D:\MyScripts\Output-Files\OfflineVM-List-$date.csv"

#$VC = Connect-VIServer $VCServerName


$Report = @()

$VMs = Get-VM | Where-Object {$_.powerstate -eq "poweredoff"}
$Datastores = Get-Datastore | Select-Object Name, Id
$VMHosts = Get-VMHost | Select-Object Name, Parent

### Get powered off event time:
Get-VIEvent -Entity $VMs -MaxSamples ([int]::MaxValue) | 
Where-Object {$_ -is [VMware.Vim.VmPoweredOffEvent]} |
Group-Object -Property {$_.Vm.Name} | %{
  $lastPO = $_.Group | Sort-Object -Property CreatedTime -Descending | select -First 1
  $vm = Get-VIObjectByVIView -MORef $lastPO.VM.VM
  $report += New-Object PSObject -Property @{
    VMName = $vm.Name
    Powerstate = $vm.Powerstate
    OS = $vm.Guest.OSFullName
    IPAddress = $vm.Guest.IPAddress[0]
    #ToolsStatus = $VMView.Guest.ToolsStatus
    Host = $vm.host.name
    Cluster = $vm.host.Parent.Name
   # Datastore = ($Datastores | where {$_.ID -match (($vmview.Datastore | Select -First 1) | Select Value).Value} | Select Name).Name
    NumCPU = $vm.NumCPU
    MemMb = [Math]::Round(($vm.MemoryMB),2)
    DiskGb = [Math]::Round((($vm.HardDisks | Measure-Object -Property CapacityKB -Sum).Sum * 1KB / 1GB),2)
    PowerOFF = $lastPO.CreatedTime
    #SSGOwner = ($vm | Get-Annotation -CustomAttribute 'SSG System Owner').Value
    #BUSowner = ($vm | Get-Annotation -CustomAttribute 'Business System Owner').Value
    Note = $vm.Notes  }
}

$Report = $Report | Sort-Object VMName

if ($Report) {
  $report | Export-Csv $ExportFilePath -NoTypeInformation}
else{
  "No PoweredOff events found"
} 


 

# $VC = Disconnect-VIServer $VCServerName -Confirm:$False
