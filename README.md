# VMware Tools for Windows

[![Build Status](https://secure.travis-ci.org/kreeuwijk/vmtools_win.png?branch=master)](http://travis-ci.org/kreeuwijk/vmtools_win)
[![Puppet Forge](https://img.shields.io/puppetforge/v/kreeuwijk/vmtools_win.svg)](https://forge.puppetlabs.com/kreeuwijk/vmtools_win)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/kreeuwijk/vmtools_win.svg)](https://forge.puppetlabs.com/kreeuwijk/vmtools_win)

#### Table of Contents

- [VMware Tools for Windows](#vmware-tools-for-windows)
      - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Module Description](#module-description)
  - [Setup](#setup)
    - [What this module affects](#what-this-module-affects)
    - [Requirements](#requirements)
    - [Beginning with this module](#beginning-with-this-module)
    - [Upgrading](#upgrading)
  - [Usage](#usage)
    - [Uninstalling VMware Tools](#uninstalling-vmware-tools)
  - [Limitations](#limitations)
    - [OS Support:](#os-support)
    - [Notes:](#notes)
    - [Issues:](#issues)
  - [Development](#development)

## Overview

This Puppet module manages the installation, configuration and removal of the Windows [Operating System Specific Packages](http://packages.vmware.com/tools/releases/latest/windows/x64) for VMware Tools. This allows you to use Windows' native tools to install, update and uninstall the VMware Tools for Windows.

## Module Description

This Puppet module manages the installation, configuration and removal of the Windows [Operating System Specific Packages](http://packages.vmware.com/tools/releases/latest/windows/x64) for VMware Tools. The OSP is still the recommended package to install for Windows (vs. open-vm-tools now being recommended for most non-Windows OS'es).

The module supports both installing the latest version from packages.vmware.com and installing any version you have downloaded yourself and made available (either on the Puppet server or somewhere else on the network).

The latest version also supports uninstalling the currently installed version of the VMware Tools.

## Setup

### What this module affects

* Downloads the latest version from packages.vmware.com if you allow it (this is the default)
* Upgrades existing versions of the VMware Tools if a lower version is found (you can configure how much lower)
* Installs the OSP VMware Tools.
* Can allow or prevent automatic reboots after installation.
* Allows you to specify which components of the VMware Tools to install
* Can be used to uninstall VMware Tools (uses msiexec /X)

### Requirements

You need to be running a Windows virtual machine on the VMware platform for this module to do anything.

### Beginning with this module

It is safe for all nodes to use this declaration.  Any non-VMware or unsupported system will skip installation of the package.
```puppet
include vmtools_win
```
Using a simple include statement will cause the defaults to be used:
* Downloads the latest version from packages.vmware.com
* Upgrades existing versions of the VMware Tools if a lower x.y.z version is found
* Installs the OSP VMware Tools with all components, prevents reboots after installation

### Upgrading

## Usage

All interaction with the vmtools_win module can be done through the main vmtools_win class. This means you can simply toggle the options in ::vmtools_win to have full functionality of the module.

To allow the latest x.y.z version (e.g. 10.1.10 regardless of specific build number) on packages.vmware.com to be installed, while preventing any automatic reboots, simply include or instantiate the class:

```puppet
class { 'vmtools_win': }
```

To set the specific level at which version checking is performed, set the following parameter:

```puppet
class { 'vmtools_win':
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
class { 'vmtools_win':
  prevent_reboot => false,
}
```

To use a self-provided version of VMware Tools that you've made available on the Puppet Master:

```puppet
class { 'vmtools_win':
  selfprovided_install_file    => 'VMware-tools-10.1.7-5541682-x86_64.exe',
  selfprovided_install_version => '10.1.7.5541682',
  selfprovided_file_source     => 'puppet:///yourcustomrepository',
}
```

### Uninstalling VMware Tools

To use the module to uninstall the VMware Tools, set the `ensure` parameter to `absent`:

```puppet
class { 'vmtools_win':
  ensure => absent
}
```

## Limitations

### OS Support:

Windows x64 Operating Systems. Tested on:
* Windows Server 2012
* Windows Server 2012 R2
* Windows Server 2016
* Windows Server 2019
* Windows Server Core (SAC)
* Windows 10

### Notes:

### Issues:

## Development

Copyright (C) 2020 Kevin Reeuwijk <kevinr@puppet.com>

Licensed under the Apache License, Version 2.0.
