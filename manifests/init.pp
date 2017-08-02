class vmtools_win (
  $download_from_vmware         = true,
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
  if $facts['virtual'] == 'vmware' {
    if $facts['vmtools_win_version'] {
      #Some version of VMware Tools must be installed...
      info ('An existing version of VMware Tools is currently installed, checking if it needs to be upgraded...')
      if $download_from_vmware {
        #Check if online facts are provisioned, which means this host's internet connection is working
        unless ($facts['vmtools_win_online_version']) and ($facts['vmtools_win_online_file']) {
          fail ('$download_from_vmware was set to true but this host is not able to access http://packages.vmware.com!')
        }
        #Check against online VMware Tools installation package
        $comparison = vmtools_win::compare_version($facts['vmtools_win_version'], $facts['vmtools_win_online_version'])
      }
      else {
        #Perform validation of self provided package parameters
        unless ($selfprovided_install_file) and ($selfprovided_install_version) and ($selfprovided_file_source) {
            fail ('You have to provide values for the $selfprovided_file_source, $selfprovided_install_file and $selfprovided_install_version parameters when you set use_packages_vmware_com to false!')
        }
        #Check against self-provided VMware Tools installation package
        $comparison = vmtools_win::compare_version($facts['vmtools_win_version'], $selfprovided_install_version)
      }
      #Now let's check if we need to upgrade, based on the returned $comparison hash
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
    else {
      notify {'There are currently no VMware Tools installed -> install needed':}
      $upgrade_needed = true
    }

    #Build values for installation or cleanup
    if $download_from_vmware {
      $file_source = 'http://packages.vmware.com/tools/releases/latest/windows/x64'
      $file_name   = $facts['vmtools_win_online_file']
    }
    else {
      $file_source = $selfprovided_file_source
      $file_name   = $selfprovided_install_file
    }

    if $upgrade_needed {
      #Build installation parameters
      $install_options_base       = ['/S', '/v"/qn']

      if $logfile_location {
        $install_options_log1   = '/l*v'
        $install_options_log2   = "\"\"${logfile_location}\"\""
      }
      else {
        $install_options_log1   = ''
        $install_options_log2   = ''
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
        $install_options_remove = ''
      }

      $install_options_extra = split("${install_options_log1} ${install_options_log2} ${install_options_reboot} ${install_options_add} ${install_options_remove}", '\s+')
      $install_options = concat($install_options_base, $install_options_extra)

      #Install VMware Tools
      file { "${local_temp_folder}/${file_name}":
        ensure => present,
        source => "${file_source}/${file_name}",
        before => Package['VMwareTools_Windows'],
      }
      package { 'VMwareTools_Windows':
        ensure          => present,
        provider        => windows,
        source          => "${local_temp_folder}/${file_name}",
        install_options => $install_options,
      }
    }
    else {
      #Cleanup installation file
      file { "${local_temp_folder}/${file_name}":
        ensure => absent,
      }
    }
  }
}
