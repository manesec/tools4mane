$rules = netsh interface portproxy show v4tov4 | Select-Object -Skip 5

if (-not $rules) {
    Write-Host "NO FOUND"
    exit
}

foreach ($rule in $rules) {
    if ($rule -match "^(\S+)\s+(\d+)") {
        $listenAddress = $matches[1]
        $listenPort = $matches[2]
        $deleteCommand = "netsh interface portproxy delete v4tov4 listenaddress=$listenAddress listenport=$listenPort"
        Invoke-Expression $deleteCommand | Out-Null
        Write-Host "[DELETED]： listenaddress=$listenAddress listenport=$listenPort" -ForegroundColor Green
    }
}
