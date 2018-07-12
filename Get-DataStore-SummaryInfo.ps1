$date = Get-Date -UFormat %Y-%m-%d-%H%M%S
$date

$ExportFilePath = "D:\MyScripts\Output-Files\DataStore_Summary-$date.csv"

Get-Datastore |`
    Select Name,@{N="TotalSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity)/1GB,0)}}, `
    @{N="UsedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace)/1GB,0)}}, `
    @{N="ProvisionedSpaceGB";E={[Math]::Round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB,0)}}, `
    @{N="NumVM";E={@($_ | Get-VM | where {$_.PowerState -eq "PoweredOn"}).Count}} | `
    Sort Name | Export-Csv -Path $ExportFilePath -NoTypeInformation
