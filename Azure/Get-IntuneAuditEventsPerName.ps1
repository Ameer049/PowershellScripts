#Requires -Modules Az, Microsoft.Graph
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Laad de authentication-module handmatig
#Import-Module Microsoft.Graph.Authentication

# Laad de directory management module (voor apparaten)
#Import-Module Microsoft.Graph.Identity.DirectoryManagement


#cverbinding maken
#Connect-MgGraph -Scopes "Device.Read.All"



[CmdletBinding()]
param(
	# Take in a deviceName to search for later on
	[Parameter(Mandatory)]
	[string]$DeviceName
)

# Connect to Graph and Azure
Connect-MgGraph
Select-MgProfile "beta"
Connect-AzAccount

# First, we'll connect to Graph and get some audit events
$auditEvents = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/auditEvents?`$filter=category eq `'Device`'&`$orderby=activityDateTime desc"
$auditEvents = $auditEvents.value

Write-Host "Earliest event: $($auditEvents[$($auditEvents.count) - 1].ActivityDateTime)"

# Then, we'll connect to the Intune Data Warehouse
# Getting an access token for the Manage API endpoint
$access = Get-AzAccessToken -ResourceUrl "https://api.manage.microsoft.com/"

# Set up our token in an Authorization header
$headers = @{ Authorization = "Bearer $($access.Token)" }



###########################################################################################################################################################
# Set our URL for the Data Warehouse. You can find yours at https://endpoint.microsoft.com/#view/Microsoft_Intune_Enrollment/ReportingMenu/~/dataWarehouse#
#                                                                                                                       ##################################
#$devicesURL = "ce/devices?api-version=v1.0"#
##########################################################################################################################
$devicesURL = "https://f"

# Page through the results, adding each page to $devicesTable
$devicesTable = @(

    # Get our results from the Data Warehouse/devices call
    $dwResults = Invoke-RestMethod -Method GET -Uri $devicesURL -Headers $headers

    # Output the results to $devicesTable
    $dwResults.value

    # Setting up the next page - so we can get all rows instead of just 10,000
    $dwResultsNextLink = $dwResults.'@odata.nextLink'

    # Page through the results
    while ($null -ne $dwResultsNextLink) {
        $dwResults = Invoke-RestMethod -Method GET -Uri $dwResultsNextLink -Headers $headers
        $dwResultsNextLink = $dwResults.'@odata.nextLink'
        # Output the new results into $devicesTable
        $dwResults.value
	}
)

# Let's find just the deviceIds we care about from the results
$matchingDWDevices = $devicesTable | Where-Object deviceName -like "*$deviceName*"

# Now we'll go through the audit events we fetched earlier and output ones that match our devices from the DW
foreach ($event in $auditEvents) {
	foreach ($device in $matchingDWDevices) {
    	if ($event.Resources.ResourceId -eq $device.deviceId) {
        	[PSCustomObject]@{
            	ResourceId = $event.Resources.ResourceId
                DateTimeUTC = $event.ActivityDateTime
                OperationType = $event.ActivityOperationType
                Result = $event.ActivityResults
                Type = $event.ActivityType
                ActorUPN = $event.Actor.UserPrincipalName
                Application = $event.Actor.ApplicationDisplayName
                ResourceName = $device.deviceName
            }
        }
    }
}



###PS C:\> .\Get-IntuneAuditEventsPerName.ps1 -deviceName Device-xxxx