$OldNTPservers='10.224.129.35','10.224.129.36'
$NewNTPservers='10.224.129.35','10.224.129.36','192.168.129.71','192.168.129.72','192.168.129.101','192.168.129.102'



#foreach($vmhost in (Get-VMHost -Name 10.224.100.73))
foreach($vmhost in (Get-VMHost -ErrorAction SilentlyContinue))

    {
        #stop ntpd service
        $vmhost | Get-VMHostService | Where-Object {$_.key -eq 'ntpd'} | Stop-VMHostService -Confirm:$false
        #$vmhost
        #remove ntpservers 
        $vmhost | Remove-VMHostNtpServer -NtpServer $OldNTPservers -Confirm:$false
        
        #add new ntpservers
        $vmhost | Add-VmHostNtpServer -NtpServer $NewNTPservers
        
        #start ntpd service
        $vmhost | Get-VMHostService | Where-Object {$_.key -eq 'ntpd'} | Start-VMHostService
    }