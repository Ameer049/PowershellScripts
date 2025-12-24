#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force


# Laad de authentication-module handmatig
#Import-Module Microsoft.Graph.Authentication

# Laad de directory management module (voor apparaten)
#Import-Module Microsoft.Graph.Identity.DirectoryManagement


#cverbinding maken
#Connect-MgGraph -Scopes "Device.Read.All"


#ObjectID van je apparaat
$ObjectId = "7840axx2-3410-4xab-8xx1-xxx"

# Apparaatgegevens ophalen
$device = Get-MgDevice -DeviceId $ObjectId

# Toon alle eigenschappen overzichtelijk
$device | Format-List *

#$device.AdditionalProperties.GetEnumerator() | Format-List


#Connect-MgGraph -Scopes "DeviceManagementServiceConfig.Read.All"

#$deviceId = "your-azure-ad-device-object-id"

#$autopilotDevices = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -All

#$matchedDevice = $autopilotDevices | Where-Object { $_.azureAdDeviceId -eq $deviceId }

#$matchedDevice | Select-Object id, serialNumber, deviceName, azureAdDeviceId
