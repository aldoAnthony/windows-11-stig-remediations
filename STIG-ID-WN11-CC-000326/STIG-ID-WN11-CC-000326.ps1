<#
.SYNOPSIS
    This PowerShell script enables PowerShell Script Block Logging.

.NOTES
    Author          : Aldo Anthony
    LinkedIn        : linkedin.com/in/aldoanthony/
    GitHub          : github.com/aldoAnthony
    Date Created    : 2026-11-23
    Last Modified   : 2026-11-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000326

.TESTED ON
    Date(s) Tested  : 2026-11-23
    Tested By       : Aldo Anthony
    Systems Tested  : Windows 11 Pro (Azure VM)
    PowerShell Ver. : 5.1

.USAGE
    Run from an elevated (Administrator) PowerShell session on the target VM.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000326.ps1
#>

#Requires -RunAsAdministrator

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$valueName    = "EnableScriptBlockLogging"
$valueData    = 1  # 1 = Enabled

# Check if the registry path exists, if not create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the EnableScriptBlockLogging value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type DWord

# Verify the change
$current = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName

if ($current -eq 1) {
    Write-Host "SUCCESS: '$valueName' is set to '$current' at '$registryPath'. WN11-CC-000326 remediated." -ForegroundColor Green
} else {
    Write-Host "FAILED: '$valueName' is '$current', expected 1." -ForegroundColor Red
    exit 1
}
