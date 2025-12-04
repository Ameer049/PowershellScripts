# Haal monitorinformatie op via WMI
$monitors = Get-WmiObject -Namespace root\wmi -Class WmiMonitorID

foreach ($monitor in $monitors) {
    # Zet de serienummer-array om naar leesbare tekst
    $serial = ($monitor.SerialNumberID | ForEach-Object {[char]$_}) -join ''
    
    # Zet het model om naar leesbare tekst
    $model = ($monitor.UserFriendlyName | ForEach-Object {[char]$_}) -join ''

    Write-Output "Monitor: $model"
    Write-Output "Serienummer: $serial"
    Write-Output "-----------------------"
}

# Pauze zodat het venster open blijft
Read-Host -Prompt "Druk op Enter om te sluiten"
