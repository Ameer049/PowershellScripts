# Huidige achtergrond ophalen uit het register
$wallpaperPath = (Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name WallPaper).WallPaper

# Controleer of het pad geldig is
if (Test-Path $wallpaperPath) {
    # E-mail instellingen
    $smtpServer = "smtp.office365.com"
    $smtpPort = 587
    $smtpFrom = "FromRmail@outlook.com"  # Vervang dit door je eigen Outlook-e-mailadres
    $smtpTo = "ReceiverEmail@outlook.com"  # Vervang dit door het e-mailadres van de ontvanger
    $subject = "Huidige Achtergrondafbeelding"
    $body = "Zie bijlage voor de huidige achtergrondafbeelding."

    # SMTP inloggegevens
    $smtpUser = "FromEmail@outlook.com"  # Vervang dit door je Outlook-e-mailadres
    $smtpPassword = "FromEmailPassword"  # Vervang dit door je Outlook-wachtwoord
    $securePassword = ConvertTo-SecureString $smtpPassword -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($smtpUser, $securePassword)

    # Verzenden van e-mail met bijlage
    Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential -Attachments $wallpaperPath -DeliveryNotificationOption OnFailure,OnSuccess

    Write-Output "Achtergrond verzonden naar $smtpTo"
} else {
    Write-Output "Geen geldige achtergrond gevonden."
}
