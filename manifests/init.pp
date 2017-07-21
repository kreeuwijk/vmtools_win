class vmtools_win (
  $use_packages_vmware_com      = false,
  $local_temp_folder            = 'C:/Windows/Temp',
  $selfprovided_install_file    = undef,   #example 'VMware-tools-10.1.7-5541682-x86_64.exe'
  $selfprovided_install_version = undef,   #example '10.1.7.5541682'
  $selfprovided_alt_source      = undef,   #example 'puppet:///filerepo'
  $minimum_major_version        = undef,   #example '10'
  $minimum_minor_version        = undef,   #example '1'
  $upgrade_if_same_major_minor  = false,
){
  if $use_packages_vmware_com {
  }
  else {
    if ($selfprovided_install_file) and ($selfprovided_install_version) {
      if (0 + $facts['vmtools_win_versionmajor']) > 0 {
        notify ('An existing version of VMware Tools is currently installed, checking if it needs to be upgraded...')
        if $facts['vmtools_win_versionmajor']
        
        if $upgrade_if_same_major_minor {
          if ($minimum_major_version) and ($minimum_minor_version) {
          }
          else {
            fail('You have to provide values for the $minimum_major_version and $minimum_minor_version parameters when you set $upgrade_if_same_major_minor to true!')
          }
        }
        else {
        }
      }
    }
    else {
      fail('You have to provide values for the $selfprovided_install_file and $selfprovided_install_version parameters when you set $use_packages_vmware_com to false!')
    }
  }



  unless $facts['vmtools_win_versionfull']=='10.1.7.5541682' {
    file { 'C:/Windows/Temp/VMware-tools-10.1.7-5541682-x86_64.exe':
      ensure => present,
      source => 'puppet:///modules/VMware-tools-10.1.7-5541682-x86_64.exe',
      before => Package['VMwareTools'],
    }
    package { 'VMwareTools':
      ensure => present,
      source => 'C:/Windows/Temp/VMware-tools-10.1.7-5541682-x86_64.exe',
      install_options => ['/S', '/v"/qn', '/l*v', '""%TEMP%\vmmsi.log""', 'REBOOT=R', 'ADDLOCAL=ALL', 'REMOVE=Hgfs"'],
    }
  }
}
