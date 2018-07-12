 #Get-VM | Get-HardDisk  | Where-Object {($_.DiskType -eq "RawVirtual")} | Select-Object -Property Parent,Name,Persistence,DiskType,Filename | Export-Csv -Path "D:\MyScripts\Output-Files\Dev-IndependentPersistent-disk-list-2016-06-22.csv"

 Get-VM | Get-HardDisk  | Where-Object {($_.Persistence -eq "IndependentPersistent") -or ($_.DiskType -eq "RawPhysical")} |Select-Object -Property Parent,Name,Persistence,DiskType,Filename |Export-Csv -Path "D:\MyScripts\Output-Files\Dev-IndependentPersistent-disk-list-2016-06-22.csv"
