class vmtools_win (
  # default values are in vmtools_win/data
  $download_from_vmware,
  $local_temp_folder,
  $selfprovided_install_file,
  $selfprovided_install_version,
  $selfprovided_file_source,
  $minimum_version_level,
  $prevent_reboot,
  $logfile_location,
  $components_to_install,
  $components_to_remove,
){

  #Build values for installation or cleanup
  if $download_from_vmware {
    $file_source = 'http://packages.vmware.com/tools/releases/latest/windows/x64'
    $file_name   = $facts['vmtools_win_online_file']
  }
  else {
    $file_source = $selfprovided_file_source
    $file_name   = $selfprovided_install_file
  }

  if vmtools_win::install_needed() {
    $install_options = vmtools_win::build_install_args()

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
