$packagestore = "https://packages.vmware.com/tools/releases/latest/windows/x64"
$r            = Invoke-WebRequest $packagestore -UseBasicParsing

if ($r.StatusCode -eq 200) {
    $packageHref    = $r.Links.HREF | ? {$_ -like "*VMware-tools*"}
    $package        = $packageHref.Split('/')[1]
    $packageversion = [regex]::Match($package, '^(\D*)(\d*.\d*.\d*-\d*)(-.*exe)$').Groups[2].Value -replace "-","."
    $packagelink    = "$packagestore/$package"
    Write-Output "vmtools_win_online_version=$packageversion"
    Write-Output "vmtools_win_online_href=$packagelink"
}
