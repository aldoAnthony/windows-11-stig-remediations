<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows System event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Aldo Anthony
    LinkedIn        : linkedin.com/in/aldoanthony/
    GitHub          : github.com/aldoAnthony
    Date Created    : 2026-11-22
    Last Modified   : 2026-11-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000510

.TESTED ON
    Date(s) Tested  : 2026-11-22
    Tested By       : Aldo Anthony
    Systems Tested  : Windows 11 Pro (Azure VM)
    PowerShell Ver. : 5.1

.USAGE
    Run from an elevated (Administrator) PowerShell session on the target VM.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AU-000510.ps1
#>

#Requires -RunAsAdministrator

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
$valueName    = "MaxSize"
$valueData    = 32768  # 0x00008000 in hexadecimal

# Check if the registry path exists, if not create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the MaxSize value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type DWord

# Verify the change
$current = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName

if ($current -ge 32768) {
    Write-Host "SUCCESS: '$valueName' is set to '$current' KB at '$registryPath'. WN11-AU-000510 remediated." -ForegroundColor Green
} else {
    Write-Host "FAILED: '$valueName' is '$current' KB, expected 32768 or greater." -ForegroundColor Red
    exit 1
}
