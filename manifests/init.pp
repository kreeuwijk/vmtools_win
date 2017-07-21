class vmtools_win (
  $use_packages_vmware_com      = false,
  $local_temp_folder            = 'C:/Windows/Temp',
  $selfprovided_install_file    = undef,   #example: 'VMware-tools-10.1.7-5541682-x86_64.exe'
  $selfprovided_install_version = undef,   #example: '10.1.7.5541682'
  $selfprovided_alt_source      = undef,   #example: 'puppet:///filerepo'
  $minimum_major_version        = undef,   #example: 10
  $minimum_minor_version        = undef,   #example: 1
  $upgrade_if_same_major_minor  = false,
){
  $upgrade_needed = false
  
  if (0 + $facts['vmtools_win_versionmajor']) > 0 {
    #Some version of VMware Tools must be installed...
    notify ('An existing version of VMware Tools is currently installed, checking if it needs to be upgraded...')
    if $use_packages_vmware_com {
      #TBD logic for checking version against online
    }
    else {
      #Check against self-provided VMware Tools installation package
      if $facts['vmtools_win_versionfull'] == $selfprovided_install_version {
        notify ('Installed version is desired version -> no upgrade needed')
        $upgrade_needed = false
      }
      else {
        notify ('Installed version does not match desired version, determining if upgrade is needed...')
        if ($selfprovided_install_file) and ($selfprovided_install_version) {
          #Required parameters are provided, continue processing...
          if $minimum_major_version {
            notify ('Minimum major version parameter provided, check major version against node...')
            if (0 + $facts['vmtools_win_versionmajor']) < $minimum_major_version {
              notify ('Installed VMware Tools is a lower major version vs the required minimum major version -> upgrade needed')
              $upgrade_needed = true
            }
            elsif (0 + $facts['vmtools_win_versionmajor']) = $minimum_major_version {
              notify ('Installed VMware Tools is the same major version vs the required minimum major version; check minor version...')
              if $minimum_minor_version {
                notify ('Minimum minor version parameter provided, check against node...')
                if (0 + $facts['vmtools_win_versionminor']) < $minimum_minor_version {
                  notify ('Installed VMware Tools is a lower minor version vs the required minimum minor version -> upgrade needed')
                  $upgrade_needed = true
                }
                elsif (0 + $facts['vmtools_win_versionminor']) = $minimum_minor_version {
                  #Installed version same major and minor version, but older or newer build; check $upgrade_if_same_major_minor parameter
                  if $upgrade_if_same_major_minor {
                    notify ('Installed VMware Tools is the same major and minor version, but a different build. $upgrade_if_same_major_minor is enabled -> upgrade needed')
                    $upgrade_needed = true
                  }
                  else {
                    notify ('Installed VMware Tools is the same major and minor version, but a different build. $upgrade_if_same_major_minor is disabled -> no upgrade needed')
                    $upgrade_needed = false
                  }
                }
                elsif (0 + $facts['vmtools_win_versionminor']) > $minimum_minor_version {
                  notify ('Installed version is higher minor version vs the required minimum minor version -> no upgrade needed')
                  $upgrade_needed = false
                }
                else {
                  fail ('Unable to compare installed minor version against $minimum_minor_version!')
                }
              }
              else {
                notify ('No minimum minor version parameter provided, assuming same minor version and falling back to $upgrade_if_same_major_minor behavior')
                if $upgrade_if_same_major_minor {
                  notify ('Installed VMware Tools is the same major and assumed minor version, but a different build. $upgrade_if_same_major_minor is enabled -> upgrade needed')
                  $upgrade_needed = true
                }
                else {
                  notify ('Installed VMware Tools is the same major and assumed minor version, but a different build. $upgrade_if_same_major_minor is disabled -> no upgrade needed')
                  $upgrade_needed = false
                }
              }
            }
            elsif (0 + $facts['vmtools_win_versionmajor']) > $minimum_major_version {
              notify ('Installed version is higher major version vs the required minimum major version -> no upgrade needed')
              $upgrade_needed = false
            }
            else {
              fail ('Unable to compare installed major version against $minimum_major_version!')
            }
          }
          else {
            notify ('No minimum major version parameter provided, assuming same major and minor version and falling back to $upgrade_if_same_major_minor behavior')
            if $upgrade_if_same_major_minor {
              notify ('Installed VMware Tools is assumed the same major and minor version, but a different build. $upgrade_if_same_major_minor is enabled -> upgrade needed')
              $upgrade_needed = true
            }
            else {
              notify ('Installed VMware Tools is assumed the same major and minor version, but a different build. $upgrade_if_same_major_minor is disabled -> no upgrade needed')
              $upgrade_needed = false
            }
          }
        }
        else {
          fail ('You have to provide values for the $selfprovided_install_file and $selfprovided_install_version parameters when you set $use_packages_vmware_com to false!')
        }
      }
    }
  }
  else {
    notify ('There are currently no VMware Tools installed -> install needed')
    $upgrade_needed = true
  }
  
  if $upgrade_needed {
    if $use_packages_vmware_com {
      #TBD logic for installing from packages.vmware.com
    }
    else {
      file { "${local_temp_folder}/${selfprovided_install_file}":
        ensure => present,
        source => [
          "puppet:///modules/${selfprovided_install_file}",
          "${selfprovided_alt_source}/${selfprovided_install_file}"
          ]
        before => Package['VMwareTools_Windows'],
      }
      package { 'VMwareTools_Windows':
        ensure => present,
        source => "${local_temp_folder}/${selfprovided_install_file}",
        install_options => ['/S', '/v"/qn', '/l*v', '""%TEMP%\vmmsi.log""', 'REBOOT=R', 'ADDLOCAL=ALL', 'REMOVE=Hgfs"'],
      } 
    }
  }
}
