# Class: vmtools_win
# Installs the VMware Tools on VMware VMs, if they are not installed or out of date
#
class vmtools_win (
  # default values are in vmtools_win/data
  $ensure,
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
  if $ensure == 'present' {
    if $facts['virtual'] == 'vmware' {
      #Sanity checks before continuing
      if $download_from_vmware {
        unless ($facts['vmtools_win_online_version']) and ($facts['vmtools_win_online_file']) {
          fail ('download_from_vmware was set to true but this host is not able to access https://packages.vmware.com!')
        }
      }
      else {
        #Perform validation of self provided package parameters
        if ($selfprovided_install_file == 'None') or ($selfprovided_install_version == 'None') or ($selfprovided_file_source == 'None') {
          fail ('You have to provide values for the selfprovided_file_source, selfprovided_install_file and selfprovided_install_version parameters when you set use_packages_vmware_com to false!') # lint:ignore:140chars
        }
      }

      #Build values for installation or cleanup
      if $download_from_vmware {
        $file_source = 'https://packages.vmware.com/tools/releases/latest/windows/x64'
        $file_name   = $facts['vmtools_win_online_file']
      }
      else {
        $file_source = $selfprovided_file_source
        $file_name   = $selfprovided_install_file
      }

      if vmtools_win::install_needed($download_from_vmware, $minimum_version_level, $selfprovided_install_version) {
        $install_options = vmtools_win::build_install_args($logfile_location, $prevent_reboot, $components_to_install, $components_to_remove) # lint:ignore:140chars

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
  elsif $ensure == 'absent' {
    exec { 'Uninstall VMware Tools':
      command  => 'msiexec /quiet /norestart /X "$((Get-ChildItem HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/Uninstall | Get-ItemProperty | ? DisplayNAME -EQ \'VMware Tools\' | Select-Object -First 1).PSChildName)"', # lint:ignore:140chars
      onlyif   => '[bool](Get-ChildItem HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/Uninstall | Get-ItemProperty | ? DisplayNAME -EQ \'VMware Tools\' | Select-Object -First 1)', # lint:ignore:140chars
      provider => powershell
    }
  }
}
