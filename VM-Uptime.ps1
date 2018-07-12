$LastBootProp = @{
  Name = 'LastBootTime'
    Expression = {
      ( Get-Date ) - ( New-TimeSpan -Seconds $_.Summary.QuickStats.UptimeSeconds )
 }
}
Get-View -ViewType VirtualMachine -Property Name, Summary.QuickStats.UptimeSeconds | Select Name, $LastBootProp
