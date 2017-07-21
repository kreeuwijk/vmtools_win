class vmtools_win (
  $use_packages_vmware_com      = true,
  $selfprovided_install_file    = 'VMware-tools-10.1.7-5541682-x86_64.exe',
  $selfprovided_install_version = '10.1.7.5541682',
  $minimum_major_version        = '10',
  $minimum_minor_version        = '1',
  $upgrade_if_same_major_minor  = false,
){
  unless $facts['vmtools_win_versionfull']=='10.1.7.5541682' {
    file { 'C:/Windows/Temp/VMware-tools-10.1.7-5541682-x86_64.exe':
      ensure => present,
      source => 'puppet:///filerepo/VMware-tools-10.1.7-5541682-x86_64.exe',
      before => Package['VMwareTools'],
    }
    package { 'VMwareTools':
      ensure => present,
      source => 'C:/Windows/Temp/VMware-tools-10.1.7-5541682-x86_64.exe',
      install_options => ['/S', '/v"/qn', '/l*v', '""%TEMP%\vmmsi.log""', 'REBOOT=R', 'ADDLOCAL=ALL', 'REMOVE=Hgfs"'],
    }
  }
}
