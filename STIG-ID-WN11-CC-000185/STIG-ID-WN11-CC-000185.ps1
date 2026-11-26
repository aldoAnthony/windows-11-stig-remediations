<#
.SYNOPSIS
    This PowerShell script configures the default AutoRun behavior to prevent autorun commands from executing.

.NOTES
    Author          : Aldo Anthony
    LinkedIn        : linkedin.com/in/aldoanthony/
    GitHub          : github.com/aldoAnthony
    Date Created    : 2026-11-22
    Last Modified   : 2026-11-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000185

.TESTED ON
    Date(s) Tested  : 2026-11-22
    Tested By       : Aldo Anthony
    Systems Tested  : Windows 11 Pro (Azure VM)
    PowerShell Ver. : 5.1

.USAGE
    Run from an elevated (Administrator) PowerShell session on the target VM.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000185.ps1
#>

#Requires -RunAsAdministrator

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName    = "NoAutorun"
$valueData    = 1  # 1 = Do not execute any autorun commands

# Check if the registry path exists, if not create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the NoAutorun value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type DWord

# Verify the change
$current = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName

if ($current -eq 1) {
    Write-Host "SUCCESS: '$valueName' is set to '$current' at '$registryPath'. WN11-CC-000185 remediated." -ForegroundColor Green
} else {
    Write-Host "FAILED: '$valueName' is '$current', expected 1." -ForegroundColor Red
    exit 1
}
