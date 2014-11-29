Set up my vagrant rails development box
=======================================

Installation
------------

-	Install git, ruby
-	Install virtualbox using the packages at [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)
-	Install vagrant using the installation instructions in the [Getting Started document](http://www.vagrantup.com/downloads.html)
-	run the following commands:

```shell
vagrant plugin install vagrant-hostmanager
mkdir -p $HOME/src && cd $HOME/src
git clone https://github.com/salimane/vagrant-rails-dev.git
cd vagrant-rails-dev/
bundle install
cd puppet && librarian-puppet install
vagrant up
vagrant provision
vagrant ssh
```

Installed components
--------------------

-	zsh
-	nginx
-	sysctl configurations for lot of connections
-	rvm + ruby 2.1.5 + 'bundle' gem
-	mysql server
-	postgresql
-	redis
-	memcached
-	heroku toolbelt
-	weighttp

Hints
-----

**Provisioning**

To provision again in case of update or errors while the virtual machine is already up, use:

```shell
vagrant provision
```

It just runs puppet to apply manifests without restarting the virtual machine.

**Restart Virtual Machine**

To restart the virtual machine, use:

```shell
vagrant halt && vagrant up

or

vagrant reload
```

**Startup speed**

To speed up the startup process after the first run, use:

```shell
vagrant up --no-provision
```

It just starts the virtual machine without provisioning of the puppet recipes.

**Rebuild**

If you messed up your box or for whatever reasons, you want to start fresh, destroy the box and build again, simply use:

```shell
vagrant destroy && vagrant up
```

It will delete the entire virtual machine and build it from scratch again.
