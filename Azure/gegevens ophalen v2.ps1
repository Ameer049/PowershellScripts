# Connect to Microsoft Graph with necessary permissions
# Only run this if not already connected
# Connect-MgGraph -Scopes "Directory.Read.All", "DeviceManagementManagedDevices.Read.All"

# Azure AD Object ID of the device
$azureDeviceId = "42fxxx8-5xxx3-4xxx0-8dbc-99xxx4cb"

# Get device info from Azure AD
try {
    $aadDevice = Get-MgDevice -DeviceId $azureDeviceId

    Write-Host "`n--- Azure AD Device Info ---"
    $aadDevice | Select-Object DisplayName, Id, DeviceId, OperatingSystem, TrustType
} catch {
    Write-Host "Failed to retrieve device from Azure AD. Ensure the Object ID is correct."
    return
}

# Now get all Intune-managed devices
try {
    $managedDevices = Get-MgDeviceManagementManagedDevice -All
} catch {
    Write-Host "Failed to retrieve Intune managed devices."
    return
}

# Match by AzureADDeviceId
$device = $managedDevices | Where-Object { $_.AzureADDeviceId -eq $azureDeviceId }

if ($device) {
    Write-Host "`n--- Intune Managed Device Info ---"
    $device | Select-Object DeviceName, Id, AzureADDeviceId, SerialNumber, UserPrincipalName, ComplianceState, ManagementAgent
} else {
    Write-Host "`nDevice not currently managed by Intune or never enrolled."
}
