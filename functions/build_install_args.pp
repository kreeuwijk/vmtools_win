function vmtools::build_install_args() >> Array {
  #Sanity checks before continuing
  if vmtools_win::download_from_vmware {
    unless ($facts['vmtools_win_online_version']) and ($facts['vmtools_win_online_file']) {
      fail ('vmtools_win::download_from_vmware was set to true but this host is not able to access http://packages.vmware.com!')
    }
  }
  else {
    #Perform validation of self provided package parameters
    unless (vmtools_win::selfprovided_install_file) and (vmtools_win::selfprovided_install_version) and (vmtools_win::selfprovided_file_source) {
      fail ('You have to provide values for the vmtools_win::selfprovided_file_source, vmtools_win::selfprovided_install_file and vmtools_win::selfprovided_install_version parameters when you set vmtools_win::use_packages_vmware_com to false!')
    }
  }

  #Build installation parameters
  $install_options_base     = ['/S', '/v"/qn']

  if vmtools_win::logfile_location {
    $install_options_log1   = '/l*v'
    $install_options_log2   = "\"\"${vmtools_win::logfile_location}\"\""
  }
  else {
    $install_options_log1   = ''
    $install_options_log2   = ''
  }

  if vmtools_win::prevent_reboot {
    $install_options_reboot = 'REBOOT=ReallySuppress'
  }
  else {
    $install_options_reboot = 'REBOOT=Suppress'
  }

  if vmtools_win::components_to_remove {
    $install_options_add    = "ADDLOCAL=${vmtools_win::components_to_install}"
    $install_options_remove = "REMOVE=${vmtools_win::components_to_remove}\""
  }
  else {
    $install_options_add    = "ADDLOCAL=${vmtools_win::components_to_install}\""
    $install_options_remove = ''
  }

  $install_options_extra = split("${install_options_log1} ${install_options_log2} ${install_options_reboot} ${install_options_add} ${install_options_remove}", '\s+')
  return concat($install_options_base, $install_options_extra)
}
