# checks what time the ESX HOST have 

foreach($esxcli in (Get-VMHost -ErrorAction SilentlyContinue | Get-EsxCli -ErrorAction SilentlyContinue))
    {
        ""|select @{n='Time';e={$esxcli.system.time.get()}},@{n='hostname';e={$esxcli.system.hostname.get().hostname}} 
    }