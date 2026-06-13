# Simple Security Posture Checker
# Saves a basic security report to the Desktop

$Report = "$env:USERPROFILE\Desktop\Security_Posture_Report.txt"

"Security Posture Checker Report" | Out-File $Report
"Generated: $(Get-Date)" | Out-File $Report -Append
"Computer: $env:COMPUTERNAME" | Out-File $Report -Append
"User: $env:USERNAME" | Out-File $Report -Append
"======================================" | Out-File $Report -Append
"" | Out-File $Report -Append

Write-Host "Running Security Posture Checker..."

# Firewall status
"1. Firewall Status" | Out-File $Report -Append
Get-NetFirewallProfile |
Select-Object Name, Enabled |
Format-Table -AutoSize |
Out-String |
Out-File $Report -Append

# Defender status
"2. Microsoft Defender Status" | Out-File $Report -Append
Get-MpComputerStatus |
Select-Object AntivirusEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled, AntivirusSignatureVersion |
Format-List |
Out-String |
Out-File $Report -Append

# Local administrators
"3. Local Administrators" | Out-File $Report -Append
Get-LocalGroupMember -Group "Administrators" |
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
Get-CimInstance Win32_StartupCommand |
Select-Object Name, Command, Location |
Format-Table -Wrap -AutoSize |
Out-String |
Out-File $Report -Append

# Processes running from common risky locations
"6. Processes Running from Downloads, Desktop, or Temp" | Out-File $Report -Append
Get-CimInstance Win32_Process |
Where-Object {
    $_.ExecutablePath -like "*\Downloads\*" -or
    $_.ExecutablePath -like "*\Desktop\*" -or
    $_.ExecutablePath -like "*\Temp\*"
} |
Select-Object Name, ProcessId, ExecutablePath |
Format-Table -Wrap -AutoSize |
Out-String |
Out-File $Report -Append

Write-Host "Scan complete."
Write-Host "Report saved to: $Report"