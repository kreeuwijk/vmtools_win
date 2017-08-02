class {'vmtools_win':
  download_from_vmware         => false,
  local_temp_folder            => 'C:/Windows/Temp',
  selfprovided_install_file    => 'VMware-tools-10.1.7-5541682-x86_64.exe',
  selfprovided_install_version => '10.1.7.5541682',
  selfprovided_file_source     => 'puppet:///filerepo',
  minimum_version_level        => 3,
  prevent_reboot               => true,
  logfile_location             => '%TEMP%\vmmsi.log',
  components_to_install        => 'ALL',
  components_to_remove         => 'Hgfs',
}

# 'minimum_version_level' determines up to which point you want to force upgrades when an existing version is found.
# When setting this level to 3 with a selfprovided_install_version of '10.1.7.5541682', this module will check up to three levels down.
# As a result it would not upgrade other 10.1.7 builds, only 10.1.6 and lower.
# To only check for 10.1 builds for example, set the minimum_version_level to 2.
# To force upgrade to the exact build, set minimum_version_level to 4.
# Downgrades will not be performed as this will cause duplicate installs of VMware Tools.
