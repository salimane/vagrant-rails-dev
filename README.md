Set up my vagrant rails development box
=======================================

Installation
------------

* Install git, ruby
* Install virtualbox using the packages at [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install vagrant using the installation instructions in the [Getting Started document](http://vagrantup.com/v1/docs/getting-started/index.html)
* run the following commands:

```shell
gem install puppet specific_install
gem specific_install -l git://github.com/maestrodev/librarian-puppet.git
vagrant plugin install vagrant-vbguest
vagrant box add vagrant-rails-dev http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-1204-x64.box
git clone https://github.com/salimane/vagrant-rails-dev.git
cd vagrant-rails-dev/puppet
librarian-puppet install --clean
vagrant up
vagrant ssh
```

Installed components
--------------------

* zsh
* nginx
* sysctl configurations for lot of connections
* rbenv + rails
* percona mysql server
* postgresql
* redis
* memcached
* heroku toolbelt
* weighttp


Hints
-----

**Startup speed**

To speed up the startup process after the first run, use:

```shell
vagrant up --no-provision
```
It just starts the virtual machine without provisioning of the puppet recipes.

