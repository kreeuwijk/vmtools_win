# Reference

## Table of Contents

**Classes**

* [`vmtools_win`](#class-vmtools_win): Installs the VMware Tools for Windows.

#### Class: `vmtools_win`

Main class.

##### Parameters

* `ensure`: Determines if VMware Tools get installed/upgraded ('present') or uninstalled ('absent').  Default: 'present'
* `download_from_vmware`: Get latest version directly from http://packages.vmware.com.  Default: true
* `local_temp_folder` : Specifies the local folder to use for temporary placement of the installation file. Default: 'C:/Windows/Temp'
* `selfprovided_install_file` : Name of the .exe file when you provide your own installation file. Must be an original VMware Tools package and normally looks like 'VMware-tools-10.1.7-5541682-x86_64.exe'. Default: not set (undef)
* `selfprovided_install_version` : The version of the VMware Tools belonging to the .exe when you provide your own installation file. Must use an fully dot'ed format, so no dashes (for example: 10.1.7.5541682). Default: not set (undef)
* `selfprovided_install_source` : Where to get the .exe when you provide your own installation file. Supports the same sources as the File{} resource in Puppet (because it will use the File resource to fetch it). Default: not set (undef)
* `minimum_version_level` : sets the specific level at which version checking is performed. The value must be an integer bigger than 0. A level is defined as the . in the full version. For example 10.1.7.5541682 would have 4 levels, with level 1 being the major version (10) and level 4 being the buildnumber (5541682). Default: 3
* `prevent_reboot` : controls if reboots are suppressed or not. When set to true, no reboots will happen even if they are necessary. When set to false, a reboot may occur if the installation of the VMware Tools determines that a reboot is needed. Default: true
* `logfile_location` : enables verbose logging to a logfile. Specify the path and name of the logfile to enable this (for example '%TEMP%\vmmsi.log'. Otherwise no logging is performed. Default: not set (undef)
* `components_to_install` : comma-separated list of VMware Tools components to install. Please use the component names as listed by vmware (https://docs.vmware.com/en/VMware-vSphere/5.5/com.vmware.vmtools.install.doc/GUID-E45C572D-6448-410F-BFA2-F729F2CDA8AC.html). In most cases it's easier to leave this value at it's default and specify `components_to_remove` instead. Default: 'ALL' 
* `components_to_remove` : comma-separated list of VMware Tools components to not install. This overrides components that would otherwise be installed via the `components_to_install` parameter. Please use the component names as listed by vmware (https://docs.vmware.com/en/VMware-vSphere/5.5/com.vmware.vmtools.install.doc/GUID-E45C572D-6448-410F-BFA2-F729F2CDA8AC.html). A common component that you may want to remove is 'Hgfs', otherwise known as VMware Shared Folders. Default: not set (undef)