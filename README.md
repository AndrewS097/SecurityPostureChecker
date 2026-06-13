# Security Posture Checker

Security Posture Checker is a basic PowerShell tool that reviews common Windows security settings and creates a simple report. The tool is designed for quick security checks, class projects, demos, and beginner-friendly Windows security testing.

## Overview

This tool checks several areas of a Windows system and saves the results to a text file on the user's Desktop. It does not make any changes to the system. It only collects information and reports what it finds.

The report includes:

* Windows Firewall status
* Microsoft Defender status
* Local administrator group members
* Local password policy
* Startup programs
* Processes running from Downloads, Desktop, or Temp folders

## Why This Tool Is Useful

A basic security posture review helps identify settings or activity that should be reviewed. For example, the tool can show if the firewall is disabled, if Defender protection is off, if there are unexpected local administrators, or if programs are running from risky user-controlled folders.

Folders like Downloads, Desktop, and Temp are not always dangerous, but they are common places where suspicious files may be launched from.

## Features

* Simple PowerShell script
* Beginner-friendly code
* Creates a readable text report
* No installation required
* Does not modify system settings
* Easy to test in a demo environment

## Requirements

* Windows 10 or Windows 11
* PowerShell
* Administrator permissions are recommended for the most complete results

## How to Run

Download or clone this repository, then open PowerShell in the folder where the script is saved.

Run the tool with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\SecurityPostureChecker.ps1
```

After the script finishes, open the report from the Desktop:

```powershell
notepad $env:USERPROFILE\Desktop\Security_Posture_Report.txt
```

## Report Location

The report is saved to:

```text
Desktop\Security_Posture_Report.txt
```

## What the Script Checks

### 1. Firewall Status

Checks whether Windows Firewall is enabled for the Domain, Private, and Public profiles.

### 2. Microsoft Defender Status

Checks Microsoft Defender settings, including:

* Antivirus enabled
* Real-time protection enabled
* Behavior monitoring enabled
* Antivirus signature version

### 3. Local Administrators

Lists users and groups that are members of the local Administrators group.

### 4. Password Policy

Displays the local password policy using the Windows `net accounts` command.

### 5. Startup Programs

Lists programs configured to run automatically when Windows starts.

### 6. Processes Running from Downloads, Desktop, or Temp

Checks for running processes that started from common user-controlled folders:

* Downloads
* Desktop
* Temp

These locations are worth reviewing because suspicious files are often launched from these folders.

## Example Use Case

This tool can be used by students, beginner security analysts, or system administrators who want a quick overview of basic Windows security settings. It is not meant to replace a full vulnerability scanner or endpoint detection tool, but it provides a simple starting point for reviewing system security.

## Limitations

* This tool only checks local Windows settings.
* It does not scan for malware.
* It does not fix security issues automatically.
* Some results may require Administrator permissions.
* Some Defender checks may not work if Microsoft Defender is not installed or is managed by another security product.

## Disclaimer

This tool is for educational and authorized security testing purposes only. Only run it on systems you own or have permission to test.
