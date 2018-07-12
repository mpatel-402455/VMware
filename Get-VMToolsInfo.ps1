 #####################################  
 ## https://github.com/mpatel-402455
 ## Tested this script on  
 ##  1) Powershell v4  
 ##  2) Powercli v6.0 Release 3  
 ##  3) Vsphere 5.5  
 ##  May 10, 2016
 ####################################

$date = Get-Date -UFormat %Y-%m-%d-%H%M%S
$date 

#$VMs= @("tordevelk01","TORORAREP04","tordevdru01")
#foreach ($vm in (Get-VM -Name tordevelk01)) { 

foreach ($vm in (Get-VM)) 
    {  
        $props = @{
        'VMName'=$vm.Name;  
        'IP Address'= $vm.Guest.IPAddress[0];
        'PowerState'= $vm.PowerState;  
        'VMTools Status' = $vm.ExtensionData.Guest.ToolsStatus;  
        'VMTools Version' = $vm.ExtensionData.Guest.ToolsVersion;  
        'VMTools Version Status' = $vm.ExtensionData.Guest.ToolsVersionStatus;  
        'VMTools Running Status' = $vm.ExtensionData.Guest.ToolsRunningStatus;  
        #'vCPU'= $vm.NumCpu;  
        'Real-OS'= $vm.guest.OSFullName;  
        'EsxiHost'= $vm.VMHost;  
        'vCenter Server' = ($vm).ExtensionData.Client.ServiceUrl.Split('/')[2].trimend(":443")  
        'Hardware Version'= $vm.Version;  
        'DataCenter' = $vm | Get-Datacenter;  
        'Note' = $vm.Notes;
    }  
        
    $obj = New-Object -TypeName PSObject -Property $Props  
     Write-Output $obj `
        | select-object -Property 'VMName', 'IP Address', 'PowerState','VMTools Status', 'VMTools Version', 'VMTools Version Status', 'VMTools Running Status', 'Real-OS', 'Note', 'EsxiHost', 'vCenter Server', 'DataCenter' `
        | Export-Csv -Path "D:\MyScripts\Output-Files\VM_Servers_VMTools_info_$date.csv" -Append
   
   } 