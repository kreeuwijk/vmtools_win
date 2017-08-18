function vmtools_win::build_install_args($logfile_location, $prevent_reboot, $components_to_install, $components_to_remove) {
  $install_options_base     = ['/S', '/v"/qn']

  if $logfile_location == 'None' {
    $install_options_log1   = ''
    $install_options_log2   = ''
  }
  else {
    $install_options_log1   = '/l*v'
    $install_options_log2   = "\"\"${$logfile_location}\"\""
  }

  if $prevent_reboot {
    $install_options_reboot = 'REBOOT=ReallySuppress'
  }
  else {
    $install_options_reboot = 'REBOOT=Suppress'
  }

  if $components_to_remove == 'None' {
    $install_options_add    = "ADDLOCAL=${components_to_install}\""
    $install_options_remove = ''
  }
  else {
    $install_options_add    = "ADDLOCAL=${components_to_install}"
    $install_options_remove = "REMOVE=${components_to_remove}\""
  }

  $install_options_extra = split("${install_options_log1} ${install_options_log2} ${install_options_reboot} ${install_options_add} ${install_options_remove}", '\s+')
  $install_options = Array.assert_type(concat($install_options_base, $install_options_extra))
  $install_options
}
