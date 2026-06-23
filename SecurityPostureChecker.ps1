# Simple Security Posture Checker
# Saves a basic security report to the Desktop

param(
    [string]$Report = "$env:USERPROFILE\Desktop\Security_Posture_Report.txt"
)

"Security Posture Checker Report" | Out-File $Report
"Generated: $(Get-Date)" | Out-File $Report -Append
"Computer: $env:COMPUTERNAME" | Out-File $Report -Append
"User: $env:USERNAME" | Out-File $Report -Append
"======================================" | Out-File $Report -Append
"" | Out-File $Report -Append

Write-Host "Running Security Posture Checker..."

# Collect data
$FirewallProfiles = @(Get-NetFirewallProfile)
$Defender = Get-MpComputerStatus
$Admins = @(Get-LocalGroupMember -Group "Administrators")
$StartupPrograms = @(Get-CimInstance Win32_StartupCommand)
$RiskyProcesses = @(Get-CimInstance Win32_Process | Where-Object {
    $_.ExecutablePath -like "*\Downloads\*" -or
    $_.ExecutablePath -like "*\Desktop\*" -or
    $_.ExecutablePath -like "*\Temp\*" -or
    $_.ExecutablePath -like "*\AppData\*"
})

# Firewall status
"1. Firewall Status" | Out-File $Report -Append
$FirewallProfiles |
Select-Object Name, Enabled |
Format-Table -AutoSize |
Out-String |
Out-File $Report -Append

# Defender status
"2. Microsoft Defender Status" | Out-File $Report -Append
$Defender |
Select-Object AntivirusEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled, AntivirusSignatureVersion |
Format-List |
Out-String |
Out-File $Report -Append

# Local administrators
"3. Local Administrators" | Out-File $Report -Append
$Admins |
Select-Object Name, ObjectClass |
Format-Table -AutoSize |
Out-String |
Out-File $Report -Append

# Password policy
"4. Password Policy" | Out-File $Report -Append
net accounts |
Out-File $Report -Append

# Startup programs
"5. Startup Programs" | Out-File $Report -Append
$StartupPrograms |
Select-Object Name, Command, Location |
Format-Table -Wrap -AutoSize |
Out-String |
Out-File $Report -Append

# Processes running from common risky locations
"6. Processes Running from Downloads, Desktop, Temp, or AppData" | Out-File $Report -Append
$RiskyProcesses |
Select-Object Name, ProcessId, ExecutablePath |
Format-Table -Wrap -AutoSize |
Out-String |
Out-File $Report -Append

# Basic findings summary
"7. Findings Summary" | Out-File $Report -Append
$Findings = 0

if ($FirewallProfiles.Enabled -contains $false) {
    "REVIEW: One or more firewall profiles are disabled." | Out-File $Report -Append
    $Findings++
}
else {
    "PASS: All firewall profiles are enabled." | Out-File $Report -Append
}

if ($Defender.RealTimeProtectionEnabled -ne $true) {
    "REVIEW: Microsoft Defender real-time protection is disabled." | Out-File $Report -Append
    $Findings++
}
else {
    "PASS: Microsoft Defender real-time protection is enabled." | Out-File $Report -Append
}

if ($Admins.Count -gt 2) {
    "REVIEW: More than two local administrator members were found." | Out-File $Report -Append
    $Findings++
}
else {
    "PASS: Local administrator membership appears limited." | Out-File $Report -Append
}

if ($RiskyProcesses.Count -gt 0) {
    "REVIEW: Processes are running from Downloads, Desktop, Temp, or AppData." | Out-File $Report -Append
    $Findings++
}
else {
    "PASS: No running processes found from common risky user folders." | Out-File $Report -Append
}

"Total items to review: $Findings" | Out-File $Report -Append

Write-Host "Scan complete."
Write-Host "Report saved to: $Report"
