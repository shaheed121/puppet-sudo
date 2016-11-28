[![Build Status](https://travis-ci.org/shaheed121/puppet-sudo.svg?branch=master)](https://travis-ci.org/shaheed121/puppet-sudo)
# puppet-sudo

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with puppet-sudo](#setup)
    * [What puppet-sudo affects](#what-puppetsudo-affects)
    * [Beginning with puppet-sudo](#beginning-with-puppetsudo)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined type](#defined_type)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Installs and manages the Sudo package.

## Setup

### What sudo affects **OPTIONAL**

This module manages the Sudo package and also it's configuration files.

### Beginning with sudo

To enable sudo module, all you simply need to do is include the class.
```
class { '::sudo' }

::sudo::rule { 'test_group':
    commands => '/usr/local/bin/test.sh',
    target   => 'root',
}
```

## Usage

To manage `/etc/sudoers` file, this module provides few configurable options.

```
class { '::sudo':
  full_sudo_groups => ['produsers'],
}
```

Configuring additional sudo access under `/etc/sudoers.d` directory for specific set of servers.

```
sudo::rule { 'test_group':
  commands => '/usr/local/bin/test.sh',
  target   => 'root'
}
```

## Reference

### Classes

This module provides the following classes:

#### Public Classes

* [sudo](#sudo)
* [sudo::logging](#sudologging)

#### Private Classes

* sudo::install
* sudo::config

#### sudo

Installs the sudo package and manages it's configuration files.

##### Parameters

###### `default_sudo_vars` (Array)

Environment variables for sudoers.

###### `full_sudo_groups` (Array)

Groups that need full privileged Access

#### sudo::logging

Configures logging for sudo.

##### Parameters

###### `enabled` (Boolean)

Enables or disables logging.

###### `log_dir` (String)

The top-level directory to use when constructing the path name for the output log directory.

###### `log_file` (String)

The path name, relative to log_dir, in which to store output logs.

###### `disable_cmnd_logging` (Array)

Array of commands for which logging will be disabled.

###### `disable_user_logging` (Array)

Array of users for which logging will be disabled.

### Defined types

The sudo module contains the following defined types:

#### Public Defined types

* [sudo::rule](#sudorule)

#### sudo::rule

##### Parameters

The following parameters are available in the `::sudo::rule` defined type:

###### `commands` (String)

Sudo commands to allow for the group.

###### `defaults` (Array)

Sudo defaults to set for the group.

###### `group` (String)

Name of the group sudo will be enabled for.

###### `target` (string)

Target users. These are the users to allow running commands as.

###### `template` (string)

Template for the file to be added under `/etc/sudoers.d/` directory.

## Limitations

Supported operating systems:
* Centos: 6, 7

Supported puppet versions:
* 4.5.0+
