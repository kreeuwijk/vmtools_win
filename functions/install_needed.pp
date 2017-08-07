function vmtools_win::install_needed($download_from_vmware, $minimum_version_level, $selfprovided_install_version = 'None') >> Boolean {
  #This function returns true if there are either older or no VMware Tools installed.
  #This function also does some sanity checking on needed parameters and will fail compilation if they aren't provided

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
      if $selfprovided_install_version == 'None' {
          fail ('You have to provide a value for $selfprovided_install_version when you set $use_packages_vmware_com to false!')
      }
      #Check against self-provided VMware Tools installation package
      $comparison = vmtools_win::compare_version($facts['vmtools_win_version'], $selfprovided_install_version)
    }
    #Now let's check if we need to upgrade, based on the returned $comparison hash
    if has_key($comparison, 'Equal') {
      info ('Installed version is desired version -> no upgrade needed')
      return false
    }
    elsif has_key($comparison, 'Lower') {
      info ('Installed version is lower version, checking if its below or above the minimum_version_level...')
      if $comparison['Lower'] <= $minimum_version_level {
        notify {'Installed version is lower version at or below the vmtools_win::minimum_version_level -> upgrade needed':}
        return true
      }
      if $comparison['Lower'] > $minimum_version_level {
        info ('Installed version is lower version but not at the vmtools_win::minimum_version_level -> no upgrade needed')
        return false
      }
    }
    elsif has_key($comparison, 'Higher') {
      info ('Installed version is higher version -> no upgrade needed')
      return false
    }
    else {
      info ('Unable to determine version comparison, skipping installation')
      return false
    }
  }
  else {
    notify {'There are currently no VMware Tools installed -> install needed':}
    return true
  }
}
