#https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2001823

# https://kb.vmware.com/selfservice/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1005937
#  Identifying virtual machines with Raw Device Mappings (RDMs) using PowerCLI 

Get-VM | Get-HardDisk -DiskType "RawPhysical", "RawVirtual" `
    | Select-Object -Property Parent,Name,DiskType,ScsiCanonicalName,DeviceName `
    | Export-Csv -Path C:\MyScripts\Output-Files\DEV-VM-with-With-RAW-Disk-Mapping.csv