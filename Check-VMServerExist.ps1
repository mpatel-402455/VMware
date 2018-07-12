
$ServerS = (Import-Csv -Path D:\MyScripts\In-Put-Files\OfflineSeversList-2016-06-07.csv)


 $i=0
 $f=0
        
            foreach ($server in $ServerS)
                {
                    $ServerName = $Server.HostName
               
                    if (Get-VM -Name $ServerName -ErrorAction SilentlyContinue)

                        {
                            Write-Host "Server found: $ServerName" -ForegroundColor Green
                            Get-VM -Name $ServerName
                            $f++
                        }
                    else 
                        {
                            Write-Host "NOT Found: $ServerName" -ForegroundColor Red
                            $SrvNotFound += "$ServerName `n"
                            $i++
                        }                                      
                }            
        

Write-Host "Following $i servers are not found:" `n$SrvNotFound -ForegroundColor Red  
 