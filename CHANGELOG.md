# Changelog

All notable changes to this project will be documented in this file.

## Release 1.1.2

**Features**
* Update changelog and readme

## Release 1.1.1

**Features**
* Switches to using HTTPS download locations and enables TLSv1.2 support in Powershell for the content checks
* Updates PDK to 2.0.0

## Release 1.1.0

**Features**
* Added official support for Windows 2019 and Windows 10
* Removed official support for Windows 2008R2
* Added support for uninstallation of VMware Tools (`ensure => absent`)
* Validated on Windows 2019 and Windows Server Core (SAC)
* Added PDK unit tests
* PDK 1.17 update

**Bugfixes**

**Known Issues**

## Release 1.0.7

**Features**
PDK 1.12 update

**Bugfixes**
ensure correct parsing of variable for reported issue #7

**Known Issues**

## Release 1.0.6

**Features**
PDK 1.8.0 update

**Bugfixes**
Fact constraints

**Known Issues**

## Release 1.0.5

**Features**
Updated to PDK-based module

**Bugfixes**

**Known Issues**

## Release 1.0.4

**Features**
Updated functions to work with PE 4.7
* removed return type definition (>>) for functions, which is PE 4.8 and above
* removed usage of 'return' function, which is PE 4.8 and above
Added testing for Puppet 5.0

**Bugfixes**

**Known Issues**

## Release 1.0.3

**Features**
* Moved validation logic to separate functions
* Moved class parameter defaults to Hiera 5 at data/common.yaml

Changed compatibility to Puppet 4.8.0 and higher, as Puppet 4.7.0 and lower do not support specifying the output datatype of a function.

**Bugfixes**

**Known Issues**

## Release 1.0.2

**Features**
Updated metadata.json to 1.0.2

**Bugfixes**

**Known Issues**

## Release 1.0.1

**Features**
This release adds support for Windows 2008 R2, which didn't fully work in 1.0.0 due to Powershell 2.0 not supporting the Invoke-WebRequest cmdlet. This is now fixed by using a different command when Invoke-WebRequest is not available.

Testing has now been performed for Windows 2008 R2, 2012, 2012 R2 and 2016.

**Bugfixes**
A bugfix was added to account for the situation where internet connectivity is not working and there is no existing version of the VMware Tools installed.

**Known Issues**

## Release 1.0.0

**Features**
Initial Release of VMware Tools for Windows puppet module.

**Bugfixes**

**Known Issues**
