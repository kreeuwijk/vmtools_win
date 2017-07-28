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

* [`vmwaretools`](#class-vmwaretools): Installs the VMware Tools Operating System Specific Packages.
* [`vmwaretools::ntp`](#class-vmwaretoolsntp): Turns off syncTime via the vmware-tools API and should be accompanied by a running NTP client on the guest.

#### Private Classes

* `vmwaretools::repo`: Installs the VMware Tools software repository.

#### Class: `vmwaretools`

Main class, includes all other classes.

##### Parameters

* `ensure`: Ensure if present or absent.  Default: present

* `autoupgrade`: Upgrade package automatically, if there is a newer version.  Default: false

* `package`: Name of the package.  Only set this if your platform is not supported or you know what you are doing.  Default: auto-set, platform specific

* `service_ensure`: Ensure if service is running or stopped.  Default: running

* `service_name`: Name of openvmtools service.  Only set this if your platform is not supported or you know what you are doing.  Default: auto-set, platform specific

* `service_enable`: Start service at boot.  Default: true

* `service_hasstatus`: Service has status command.  Only set this if your platform is not supported or you know what you are doing.  Default: auto-set, platform specific

* `service_hasrestart`: Service has restart command.  Default: true

* `tools_version`: The version of VMware Tools to install.  Possible values can be found here: http://packages.vmware.com/tools/esx/index.html Default: latest

* `disable_tools_version`: Whether to report the version of the tools back to vCenter/ESX.  Default: true (ie do not report)

* `manage_repository`: Whether to allow the repo to be manged by the module or out of band (ie RHN Satellite).  Default: true (ie let the module manage it)

* `reposerver`: The server which holds the YUM repository.  Customize this if you mirror public YUM repos to your internal network.  Default: http://packages.vmware.com

* `repopath`: The path on *reposerver* where the repository can be found.  Customize this if you mirror public YUM repos to your internal network.  Default: /tools

* `just_prepend_repopath`: Whether to prepend the overridden *repopath* onto the default *repopath* or completely replace it.  Only works if *repopath* is specified.  Default: 0 (false)

* `gpgkey_url`: The URL where the public GPG key resides for the repository NOT including the GPG public key file itself (ending with a trailing /).  Default: ${reposerver}${repopath}/

* `priority`: Give packages in this YUM repository a different weight.  Requires yum-plugin-priorities to be installed.  Default: 50

* `protect`: Protect packages in this YUM repository from being overridden by packages in non-protected repositories.  Default: 0 (false)

* `proxy`: The URL to the proxy server for this repository.  Default: absent

* `proxy_username`: The username for the proxy.  Default: absent

* `proxy_password`: The password for the proxy.  Default: absent

* `scsi_timeout`: This will adjust the scsi timout value set in udev rules.  This file is created by the VMWare Tools installer.  Defualt: 180

#### Class: `vmwaretools::ntp`

This class handles turning off syncTime via the vmware-tools API and should be accompanied by a running NTP daemon on the guest.

##### Parameters

None


## Limitations

### OS Support:

VMware Tools Operating System Specific Packages official [supported guest operating systems](http://packages.vmware.com/) are available for these operating systems:

* Community ENTerprise Operating System (CentOS)
  * 4.0 through 6.x
* Red Hat Enterprise Linux
  * 3.0 through 6.x
* SUSE Linux Enterprise Server
  * 9 through 11
* SUSE Linux Enterprise Desktop
  * 10 through 11
* Ubuntu Linux
  * 8.04 through 12.04

### Notes:

* Only tested on CentOS 5.5+ and CentOS 6.2+ x86_64 with 4.0latest.
* Not supported on Fedora or Debian as these distros are not supported by the OSP.
* Not supported on RHEL/CentOS/OEL 7+ or SLES 12 as VMware is [recommending
  open-vm-tools](http://kb.vmware.com/kb/2073803) instead.  Use
  [razorsedge/openvmtools](https://forge.puppetlabs.com/razorsedge/openvmtools)
  instead.
* Supports repo proxy, proxy_username, proxy_password, priorities, yum repo
  protection, and using a local mirror for the reposerver and repopath.
* Supports not managing the repo configuration via `manage_repository => false`.
* No other VM tools (ie [Open Virtual Machine
  Tools](http://open-vm-tools.sourceforge.net/)) will be supported.

### Issues:

* Does not install Desktop (X Window) components.
* Does not handle RHEL5 i386 PAE kernel on OSP 5.0+.

## Development

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for information on how to contribute.

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

Licensed under the Apache License, Version 2.0.

[razorsedge/puppet-vmwaretools on GitHub](https://github.com/razorsedge/puppet-vmwaretools)

[razorsedge/vmwaretools on Puppet Forge](https://forge.puppetlabs.com/razorsedge/vmwaretools)

