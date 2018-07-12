#####################################                                                                
  ## http://kunaludapi.blogspot.com                                                                
  ## Version: 2                                                               
  ## Date: 16 Dec 2015                                                              
  ## Script tested on below platform                                                                
  ## 1) Powershell v4                                                               
  ## 2) Powercli v5.5                                                                
  ## 3) Vsphere 5.5                                                               
  ####################################                                                               
  #Add-PSSnapin vmware.vimautomation.core                                                               
  #Connect-Viserver #vcenterserver                                                                
                                                               
 function Get-DatastoreInventory {                                                               
   $HostDatastoreInfo = Get-VMHost | Get-ScsiLun -LunType disk                                                                
   $DatastoreInfo = Get-Datastore                                                               
   foreach ($Hostdatastore in $HostDatastoreInfo) {                                                                
    $Datastore = $DatastoreInfo | Where-Object {$_.extensiondata.info.vmfs.extent.Diskname -match $Hostdatastore.CanonicalName}                                                               
    $LunPath = $Hostdatastore | Get-ScsiLunPath                                                              
    if ($Datastore.ExtensionData.vm) {                                                               
     $VMsOnDatastore = $(Get-view $Datastore.ExtensionData.vm).name -join ","                                                               
    } #if                                                               
    else {$VMsOnDatastore = "No VMs"}                                                               
                                                                 
   #Work on not assigned Luns error at silentlyContinue                                                               
    if ($Datastore.Name -eq $null) {                                                              
     $DatastoreName = "Not mapped"                                                              
     $FileSystemVersion = "Not mapped"                                                              
    }                                                              
    else {                                                              
     $DatastoreName = $Datastore.Name -join ","                                                              
     $FileSystemVersion = $Datastore[0].FileSystemVersion                                                               
    }                                                              
                                                                   
    $DatastoreFreeSpace = $Datastore.FreeSpaceGB -join ", "                                                               
    $DatastoreCapacityGB = $Datastore.CapacityGB -join ", "                                                               
    $DatastoreDatacenter = $Datastore.Datacenter -join ", "                                                               
                                                               
    $State = $LunPath.State -join ", "                                                              
    $Preferred = $LunPath.Preferred -join ", "                                                              
    $Paths = ($LunPath.ExtensionData.Transport | foreach {($_.Address -split ":")[0]}) -Join ", "                                                              
    $IsWorkingPath = $LunPath.ExtensionData.IsWorkingPath -Join ", "                                                              
                                                                  
    $Obj = New-Object PSObject                                                               
    $Obj | Add-Member -Name VMhost -MemberType NoteProperty -Value $hostdatastore.VMHost                                                               
    $Obj | Add-Member -Name DatastoreName -MemberType NoteProperty -Value $DatastoreName                                                                
    $Obj | Add-Member -Name FreeSpaceGB -MemberType NoteProperty -Value $DatastoreFreeSpace                                                               
    $Obj | Add-Member -Name CapacityGB -MemberType NoteProperty -Value $DatastoreCapacityGB                                                               
    $Obj | Add-Member -Name FileSystemVersion -MemberType NoteProperty -Value $FileSystemVersion                                                               
    $Obj | Add-Member -Name RuntimeName -MemberType NoteProperty -Value $hostdatastore.RuntimeName                                                               
    $Obj | Add-Member -Name CanonicalName -MemberType NoteProperty -Value $hostdatastore.CanonicalName                                                               
    $Obj | Add-Member -Name MultipathPolicy -MemberType NoteProperty -Value $hostdatastore.MultipathPolicy                                                               
    $Obj | Add-Member -Name Vendor -MemberType NoteProperty -Value $hostdatastore.Vendor                                                               
    $Obj | Add-Member -Name DatastoreDatacenter -MemberType NoteProperty -Value $DatastoreDatacenter                                                               
    $Obj | Add-Member -Name VMsOnDataStore -MemberType NoteProperty -Value $VMsOnDatastore                                                               
    $Obj | Add-Member -Name NumberOfPaths -MemberType NoteProperty -Value $LunPath.Count                                                              
    $Obj | Add-Member -Name Paths -MemberType NoteProperty -Value $Paths                                                              
    $Obj | Add-Member -Name State -MemberType NoteProperty -Value $State                                                              
    $Obj | Add-Member -Name Preferred -MemberType NoteProperty -Value $Preferred                                                              
    $Obj | Add-Member -Name IsWorkingPath -MemberType NoteProperty -Value $IsWorkingPath                                                              
    $Obj                                                               
   }                                                               
  }                                                               
  Get-DatastoreInventory | Export-Csv -NoTypeInformation "C:\MyScripts\Output-Files\DatastoreInfoHostwise.csv"     