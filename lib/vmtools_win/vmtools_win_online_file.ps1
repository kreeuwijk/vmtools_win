[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$packagestore = "https://packages.vmware.com/tools/releases/latest/windows/x64"
$success = $false

if (Get-Command 'Invoke-WebRequest' -ErrorAction SilentlyContinue) {
    $type = 'IWR'
    Try {
       $r = Invoke-WebRequest $packagestore -UseBasicParsing
    }
    Catch {}
    if ($r.StatusCode -eq 200) { $success = $true }
}
else {
    $type = 'WC'
    Try {
        $r = (New-Object System.Net.WebClient).DownloadString($packagestore)
    }
    Catch {}
    if ($r) {$success = $true}
}

if ($success) {
    Switch ($type) {
        'IWR' { $packageHref = $r.Links.HREF | ? {$_ -like "*VMware-tools*"} }
        'WC'  { $packageHref = [regex]::Match($r, '(x64/\D*)(\d*.\d*.\d*-\d*)(-.*exe)').Value }
    }
    $package        = $packageHref.Split('/')[1]
    $packagelink    = "$package"
    Write-Output "$packagelink"
}
