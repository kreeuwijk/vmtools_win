$arrVMtools = @(Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | get-itemproperty | ? {$_.DisplayName -eq "VMware Tools"})
if ($arrVMtools.Count -gt 0) {
  write-output (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | get-itemproperty | ? {$_.DisplayName -eq "VMware Tools"} | Sort-Object -Property InstallDate -Descending | Select-Object -First 1 -Property DisplayVersion).DisplayVersion
}
