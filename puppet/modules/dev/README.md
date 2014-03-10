# Puppet Module to setup a rails env

Setup dev module in [vagrant-rails-dev](http://github.com/salimane/vagrant-rails-dev.git)

## Usage

```puppet
include dev
```

## Required Puppet Modules

* [`sqlite3`](git://github.com/puppetlabs/puppetlabs-sqlite.git)

* [`epel`](git://github.com/stahnma/puppet-module-epel.git)

* [`stdlib`](git://github.com/puppetlabs/puppetlabs-stdlib.git)

* [`nginx`](git://github.com/jfryman/puppet-nginx.git)

* [`ntp`](git://github.com/puppetlabs/puppetlabs-ntp.git)

* [`concat`](git://github.com/ripienaar/puppet-concat.git)

* [`mysql`](git://github.com/puppetlabs/puppetlabs-mysql.git)

* [`sysctl`](https://github.com/thias/puppet-sysctl)

* [`sudo`](git@github.com:saz/puppet-sudo.git)

* [`rvm`](https://github.com/maestrodev/puppet-rvm.git)

* [`firewall`](https://github.com/puppetlabs/puppetlabs-firewall)

## Development

Write Code. Test it. Send a Pull Request.
