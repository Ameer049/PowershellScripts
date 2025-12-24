# Stap 1: Zorg dat Microsoft Graph module geïnstalleerd is
#Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Stap 2: Maak verbinding met Graph API met voldoende rechten
Connect-MgGraph -Scopes Device.Read.All

# Stap 3: Zet je Device ID in een variabele
$deviceId = "94bf79"

# Stap 4: Haal details op van dat specifieke device
$device = Get-MgDevice -DeviceId $deviceId

# Stap 5: Toon alle beschikbare eigenschappen
$device | Format-List *

# Optioneel: toon alleen een selectie inclusief PhysicalIds
[PSCustomObject]@{
    DisplayName     = $device.DisplayName
    DeviceId        = $device.Id
    ObjectId        = $device.Id
    DeviceOSType    = $device.DeviceOSType
    DeviceTrustType = $device.DeviceTrustType
    JoinType        = $device.DeviceJoinType
    LastSignIn      = $device.ApproximateLastSignInDateTime
    PhysicalIds     = $device.PhysicalIds -join "; "
}
