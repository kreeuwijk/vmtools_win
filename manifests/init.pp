#Example usage in your profile:
#  class profile::windows::vmwaretools {
#    class {'vmtools_win':
#      download_from_vmware         => false,
#      local_temp_folder            => 'C:/Windows/Temp',
#      selfprovided_install_file    => 'VMware-tools-10.1.7-5541682-x86_64.exe',
#      selfprovided_install_version => '10.1.7.5541682',
#      selfprovided_file_source     => 'puppet:///filerepo',
#      minimum_version_level        => 3,
#      prevent_reboot               => true,
#      logfile_location             => '%TEMP%\vmmsi.log',
#      components_to_install        => 'ALL',
#      components_to_remove         => 'Hgfs',
#    }
#  }

# 'minimum_version_level' determines up to which point you want to force upgrades when an existing version is found.
# When setting this level to 3 with a selfprovided_install_version of '10.1.7.5541682', this module will check up to three levels down.
# As a result it would not upgrade other 10.1.7 builds, only 10.1.6 and lower.
# To only check for 10.1 builds for example, set the minimum_version_level to 2.
# To force upgrade to the exact build, set minimum_version_level to 4.
# Downgrades will not be performed as this will cause duplicate installs of VMware Tools.

class vmtools_win (
  $download_from_vmware         = false,
  $local_temp_folder            = 'C:/Windows/Temp',
  $selfprovided_install_file    = undef,   #example: 'VMware-tools-10.1.7-5541682-x86_64.exe'
  $selfprovided_install_version = undef,   #example: '10.1.7.5541682'
  $selfprovided_file_source     = undef,   #example: 'puppet:///filerepo'
  $minimum_version_level        = 3,
  $prevent_reboot               = true,
  $logfile_location             = undef,
  $components_to_install        = 'ALL',
  $components_to_remove         = undef,
){
  if length($facts['vmtools_win_version']) > 0 {
    #Some version of VMware Tools must be installed...
    info ('An existing version of VMware Tools is currently installed, checking if it needs to be upgraded...')
    if $download_from_vmware {
      #TBD logic for checking version against online
      #https://packages.vmware.com/tools/esx/latest/windows/index.html
    }
    else {
      #Perform validation of self provided package parameters
      unless ($selfprovided_install_file) and ($selfprovided_install_version) and ($selfprovided_file_source) {
          fail ('You have to provide values for the $selfprovided_file_source, $selfprovided_install_file and $selfprovided_install_version parameters when you set use_packages_vmware_com to false!')
      }
      
      #Check against self-provided VMware Tools installation package
      $comparison = vmtools_win::compare_version($facts['vmtools_win_version'], $selfprovided_install_version)
      
      if has_key($comparison, 'Equal') {
        info ('Installed version is desired version -> no upgrade needed')
        $upgrade_needed = false
      }
      elsif has_key($comparison, 'Lower') {
        info ('Installed version is lower version, checking if its below or above the minimum_version_level...')
        if $comparison['Lower'] <= $minimum_version_level {
          notify {'Installed version is lower version at or below the minimum_version_level -> upgrade needed':}
          $upgrade_needed = true
        }
        if $comparison['Lower'] > $minimum_version_level {
          info ('Installed version is lower version but not at the minimum_version_level -> no upgrade needed')
          $upgrade_needed = false
        }
      }
      elsif has_key($comparison, 'Higher') {
        info ('Installed version is higher version -> no upgrade needed')
        $upgrade_needed = false
      }
      else {
        info ('Unable to determine version comparison, skipping installation')
        $upgrade_needed = false
      }
    }
  }
  else {
    notify {'There are currently no VMware Tools installed -> install needed':}
    $upgrade_needed = true
  }
  
  if $upgrade_needed {
    if $download_from_vmware {
      #TBD logic for installing from packages.vmware.com
    }
    else {
      $install_options_base       = ['/S', '/v"/qn']
      
      if $logfile_location {
        $install_options_log1   = '/l*v'
        $install_options_log2   = "\"\"${logfile_location}\"\""
      }
      else {
        $install_options_log1   = ""
        $install_options_log2   = ""
      }
      
      if $prevent_reboot {
        $install_options_reboot = 'REBOOT=ReallySuppress'
      }
      else {
        $install_options_reboot = 'REBOOT=Suppress'
      }
      
      if $components_to_remove {
        $install_options_add    = "ADDLOCAL=${components_to_install}"
        $install_options_remove = "REMOVE=${components_to_remove}\""
      }
      else {
        $install_options_add    = "ADDLOCAL=${components_to_install}\""
        $install_options_remove = ""
      }
      
      $install_options_extra = split("${install_options_log1} ${install_options_log2} ${install_options_reboot} ${install_options_add} ${install_options_remove}", '\s+')
      $install_options = concat($install_options_base, $install_options_extra)
      
      file { "${local_temp_folder}/${selfprovided_install_file}":
        ensure => present,
        source => "${selfprovided_file_source}/${selfprovided_install_file}",
        before => Package['VMwareTools_Windows'],
      }
      package { 'VMwareTools_Windows':
        ensure          => present,
        provider        => windows,
        source          => "${local_temp_folder}/${selfprovided_install_file}",
        install_options => $install_options,
      } 
    }
  }
}
