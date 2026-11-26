# Windows 11 STIG Remediations 🔒

PowerShell scripts that remediate failed DISA STIG checks on a Windows 11 Pro VM in Azure, completed as part of my LOG(N) Pacific cybersecurity internship.

## Method

Each STIG follows the same three steps:

1. **Scan:** run an authenticated Tenable compliance scan using the DISA Microsoft Windows 11 STIG audit and identify the failed check.
2. **Remediate:** write and run a PowerShell script that applies the required setting.
3. **Verify:** rescan with Tenable and confirm the check now passes.

**Environment:** Windows 11 Pro (Azure VM) · Tenable Vulnerability Management (LOCAL-SCAN-ENGINE-01) · DISA Microsoft Windows 11 STIG V2R11 · PowerShell 5.1

## Remediated STIGs

| # | STIG ID | What it fixes | Script | Result |
|---|---|---|---|---|
| 1 | WN11-AU-000505 | Security event log must hold at least a week of audit records (MaxSize ≥ 5120000 KB) | [STIG-ID-WN11-AU-000505.ps1](STIG-ID-WN11-AU-000505.ps1) | ✅ Passed |
| 2 | WN11-AU-000510 | System event log must be 32768 KB or greater | [STIG-ID-WN11-AU-000510.ps1](STIG-ID-WN11-AU-000510.ps1) | ✅ Passed |
| 3 | WN11-CC-000005 | Camera access from the lock screen must be disabled | [STIG-ID-WN11-CC-000005.ps1](STIG-ID-WN11-CC-000005.ps1) | ✅ Passed |
| 4 | WN11-CC-000010 | Slide shows on the lock screen must be disabled | [STIG-ID-WN11-CC-000010.ps1](STIG-ID-WN11-CC-000010.ps1) | ✅ Passed |
| 5 | WN11-CC-000180 | AutoPlay must be turned off for non-volume devices (CAT I) | [STIG-ID-WN11-CC-000180.ps1](STIG-ID-WN11-CC-000180.ps1) | ✅ Passed |
| 6 | WN11-CC-000185 | Default AutoRun behaviour must prevent autorun commands (CAT I) | [STIG-ID-WN11-CC-000185.ps1](STIG-ID-WN11-CC-000185.ps1) | ✅ Passed |
| 7 | WN11-CC-000190 | AutoPlay must be disabled for all drives (CAT I) | [STIG-ID-WN11-CC-000190.ps1](STIG-ID-WN11-CC-000190.ps1) | ✅ Passed |

## Evidence

### 1. WN11-AU-000505: Security event log size

**Finding:** no maximum size was configured for the Security event log, so audit records could be overwritten before anyone reviewed them. Tenable expects a value of at least 5120000 KB.

**Fix:** set `MaxSize = 5120000` (DWORD) under `HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security`. This is an upper limit, so Windows doesn't reserve the disk space up front.

<details>
<summary>Before: check failed</summary>

![Tenable scan showing WN11-AU-000505 failed](screenshots/WN11-AU-000505/1-before-scan-failed.png)
![Audit details and solution for WN11-AU-000505](screenshots/WN11-AU-000505/2-before-audit-details.png)
![Audit output NULL against policy value 5120000 or more](screenshots/WN11-AU-000505/3-before-output-null.png)

</details>

<details>
<summary>Remediation: script run</summary>

![PowerShell output showing MaxSize set to 5120000](screenshots/WN11-AU-000505/4-script-success.png)

</details>

<details>
<summary>After: check passed</summary>

![Tenable rescan showing WN11-AU-000505 passed](screenshots/WN11-AU-000505/5-after-scan-passed.png)
![Audit output 5120000 meeting the policy value](screenshots/WN11-AU-000505/6-after-output-5120000.png)

</details>

### 2. WN11-AU-000510: System event log size

**Finding:** no maximum size was configured for the System event log. If the log is too small, older events are overwritten quickly and lost before anyone can investigate them. Tenable expects a value of at least 32768 KB.

**Fix:** set `MaxSize = 32768` (DWORD) under `HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System`.

<details>
<summary>Before: check failed</summary>

![Tenable scan showing WN11-AU-000510 failed](screenshots/WN11-AU-000510/1-before-scan-failed.png)
![Audit details and solution for WN11-AU-000510](screenshots/WN11-AU-000510/2-before-audit-details.png)
![Audit output NULL against policy value 32768 or more](screenshots/WN11-AU-000510/3-before-output-null.png)

</details>

<details>
<summary>Remediation: script run</summary>

![PowerShell output showing MaxSize set to 32768](screenshots/WN11-AU-000510/4-script-success.png)

</details>

<details>
<summary>After: check passed</summary>

![Tenable rescan showing WN11-AU-000510 passed](screenshots/WN11-AU-000510/5-after-scan-passed.png)
![Audit output 32768 meeting the policy value](screenshots/WN11-AU-000510/6-after-output-32768.png)

</details>

### 3. WN11-CC-000005: Lock screen camera disabled

**Finding:** camera access from the lock screen was not disabled, so anyone with physical access to a locked device could take photos or video without signing in. Azure VMs have no camera, but Tenable still checks the registry value.

**Fix:** set `NoLockScreenCamera = 1` (DWORD) under `HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization`.

<details>
<summary>Before: check failed</summary>

![Tenable scan showing WN11-CC-000005 failed](screenshots/WN11-CC-000005/1-before-scan-failed.png)
![Audit details and solution for WN11-CC-000005](screenshots/WN11-CC-000005/2-before-audit-details.png)
![Audit output NULL against policy value 1](screenshots/WN11-CC-000005/3-before-output-null.png)

</details>

<details>
<summary>Remediation: script run</summary>

![PowerShell output showing the setting applied](screenshots/WN11-CC-000005/4-script-success.png)

</details>

<details>
<summary>After: check passed</summary>

![Tenable rescan showing WN11-CC-000005 passed](screenshots/WN11-CC-000005/5-after-scan-passed.png)
![Audit output 1 matching the policy value](screenshots/WN11-CC-000005/6-after-output-1.png)

</details>

### 4. WN11-CC-000010: Lock screen slide show disabled

**Finding:** the lock screen slide show was not disabled, so anyone standing at a locked device could see personal or sensitive images.

**Fix:** set `NoLockScreenSlideshow = 1` (DWORD) under `HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization`.

<details>
<summary>Before: check failed</summary>

![Tenable scan showing WN11-CC-000010 failed](screenshots/WN11-CC-000010/1-before-scan-failed.png)
![Audit details and solution for WN11-CC-000010](screenshots/WN11-CC-000010/2-before-audit-details.png)
![Audit output NULL against policy value 1](screenshots/WN11-CC-000010/3-before-output-null.png)

</details>

<details>
<summary>Remediation: script run</summary>

![PowerShell output showing the setting applied](screenshots/WN11-CC-000010/4-script-success.png)

</details>

<details>
<summary>After: check passed</summary>

![Tenable rescan showing WN11-CC-000010 passed](screenshots/WN11-CC-000010/5-after-scan-passed.png)
![Audit output 1 matching the policy value](screenshots/WN11-CC-000010/6-after-output-1.png)

</details>

### 5. WN11-CC-000180: AutoPlay off for non-volume devices (CAT I)

**Finding:** AutoPlay was allowed for non-volume devices such as phones, cameras and media players connected over MTP. A malicious device could use AutoPlay to start actions without the user doing anything.

**Fix:** set `NoAutoplayfornonVolume = 1` (DWORD) under `HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer`.

<details>
<summary>Before: check failed</summary>

![Tenable scan showing WN11-CC-000180 failed](screenshots/WN11-CC-000180/1-before-scan-failed.png)
![Audit details and solution for WN11-CC-000180](screenshots/WN11-CC-000180/2-before-audit-details.png)
![Audit output NULL against policy value 1](screenshots/WN11-CC-000180/3-before-output-null.png)

</details>

<details>
<summary>Remediation: script run</summary>

![PowerShell output showing the setting applied](screenshots/WN11-CC-000180/4-script-success.png)

</details>

<details>
<summary>After: check passed</summary>

![Tenable rescan showing WN11-CC-000180 passed](screenshots/WN11-CC-000180/5-after-scan-passed.png)
![Audit output 1 matching the policy value](screenshots/WN11-CC-000180/6-after-output-1.png)

</details>

### 6. WN11-CC-000185: AutoRun commands blocked (CAT I)

**Finding:** Windows could automatically run the commands in an autorun.inf file when media was inserted. Malware has spread through USB drives this way for years.

**Fix:** set `NoAutorun = 1` (DWORD) under `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer`. Note this path is different from STIG 5: it sits under `CurrentVersion\Policies`, not `Policies\Microsoft\Windows`.

<details>
<summary>Before: check failed</summary>

![Tenable scan showing WN11-CC-000185 failed](screenshots/WN11-CC-000185/1-before-scan-failed.png)
![Audit details and solution for WN11-CC-000185](screenshots/WN11-CC-000185/2-before-audit-details.png)
![Audit output NULL against policy value 1](screenshots/WN11-CC-000185/3-before-output-null.png)

</details>

<details>
<summary>Remediation: script run</summary>

![PowerShell output showing the setting applied](screenshots/WN11-CC-000185/4-script-success.png)

</details>

<details>
<summary>After: check passed</summary>

![Tenable rescan showing WN11-CC-000185 passed](screenshots/WN11-CC-000185/5-after-scan-passed.png)
![Audit output 1 matching the policy value](screenshots/WN11-CC-000185/6-after-output-1.png)

</details>

### 7. WN11-CC-000190: AutoPlay off for all drives (CAT I)

**Finding:** AutoPlay was still on for some drive types, including USB drives, CDs and network drives. Windows could then launch content automatically when media was inserted, a common way for malware to get onto a machine.

**Fix:** set `NoDriveTypeAutoRun = 255` (DWORD, `0xFF`) under `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer`, the same key as STIG 6. The value 255 is a bitmask that turns AutoPlay off for every drive type.

<details>
<summary>Before: check failed</summary>

![Tenable scan showing WN11-CC-000190 failed](screenshots/WN11-CC-000190/1-before-scan-failed.png)
![Audit details and solution for WN11-CC-000190](screenshots/WN11-CC-000190/2-before-audit-details.png)
![Audit output NULL against policy value 255](screenshots/WN11-CC-000190/3-before-output-null.png)

</details>

<details>
<summary>Remediation: script run</summary>

![PowerShell output showing the setting applied](screenshots/WN11-CC-000190/4-script-success.png)

</details>

<details>
<summary>After: check passed</summary>

![Tenable rescan showing WN11-CC-000190 passed](screenshots/WN11-CC-000190/5-after-scan-passed.png)
![Audit output 255 matching the policy value](screenshots/WN11-CC-000190/6-after-output-255.png)

</details>

---

Part of my [Cybersecurity Internship Portfolio](https://github.com/aldoAnthony/Cyber-Security-Internship-Portfolio).
