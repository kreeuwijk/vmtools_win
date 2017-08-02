# VMware Tools for Windows

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with this module](#setup)
    * [What this module affects](#what-this-module-affects)
    * [What this module requires](#requirements)
    * [Beginning with this module](#beginning-with-this-module)
    * [Upgrading](#upgrading)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
    * [OS Support](#os-support)
    * [Notes](#notes)
    * [Issues](#issues)
6. [Development - Guide for contributing to the module](#development)

## Overview

This Puppet module manages the installation and configuration of the Windows [Operating System Specific Packages](http://packages.vmware.com/tools/releases/latest/windows/x64) for VMware Tools. This allows you to use Windows' native tools to install and update the VMware Tools for Windows.

## Module Description

This Puppet module manages the installation and configuration of the Windows [Operating System Specific Packages](http://packages.vmware.com/tools/releases/latest/windows/x64) for VMware Tools. The OSP is still the recommended package to install for Windows (vs. open-vm-tools now being recommended for most non-Windows OS'es).

The module supports both installing the latest version from packages.vmware.com and installing any version you have downloaded yourself and made available (either on the Puppet server or somewhere else on the network).

## Setup

### What this module affects

* Downloads the latest version from packages.vmware.com if you allow it (this is the default)
* Upgrades existing versions of the VMware Tools if a lower version is found (you can configure how much lower)
* Installs the OSP VMware Tools.
* Can allow or prevent automatic reboots after installation.
* Allows you to specify which components of the VMware Tools to install

### Requirements

You need to be running a Windows virtual machine on the VMware platform for this module to do anything.

### Beginning with this module

It is safe for all nodes to use this declaration.  Any non-VMware or unsupported system will skip installation of the package.
```puppet
include vmtools_win
```

### Upgrading

## Usage

All interaction with the vmtools_win module can be done through the main vmtools_win class. This means you can simply toggle the options in ::vmtools_win to have full functionality of the module.

To allow the latest x.y.z version (e.g. 10.1.10 regardless of specific build number) on packages.vmware.com to be installed, while preventing any automatic reboots, simply include the class:

```puppet
include vmtools_win
```

To set the specific level at which version checking is performed, set the following parameter:

```puppet
class { 'vmwaretools':
  minimum_version_level => 2,
}
```

The levels have the following effect:
* level 1 -> only looks at the major version (e.g. 10)
* level 2 -> looks at the major and minor version (e.g. 10.1)
* level 3 -> looks at the major, minor and micro version (e.g. 10.1.10)
* level 4 -> looks at the major, minor, micro and build version (e.g. 10.1.10.6082533)

To allow reboots when required after installation:

```puppet
class { 'vmwaretools':
  prevent_reboot => false,
}
```

To use a self-provided version of VMware Tools that you've made available on the Puppet Master:

```puppet
class { 'vmwaretools':
  selfprovided_install_file    => 'VMware-tools-10.1.7-5541682-x86_64.exe',
  selfprovided_install_version => '10.1.7.5541682',
  selfprovided_file_source     => 'puppet:///yourcustomrepository',
}
```

## Reference

### Classes

#### Public Classes

* [`vmtools_win`](#class-vmtools_win): Installs the VMware Tools for Windows.

#### Private Classes

None

#### Class: `vmtools_win`

Main class.

##### Parameters

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

## Limitations

### OS Support:

Windows x64 Operating Systems. Tested on:
* Windows Server 2008 R2
* Windows Server 2012
* Windows Server 2012 R2
* Windows Server 2016

### Notes:

### Issues:

## Development

Copyright (C) 2017 Kevin Reeuwijk <kevinr@puppet.com>

Licensed under the Apache License, Version 2.0.
