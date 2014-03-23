# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.5.0"

Vagrant.configure("2") do |config|

  config.vm.box = "vagrant-rails-dev"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.vm.define 'vagrant-rails-dev' do |node|
    node.vm.hostname = 'vagrant.rails.com'
    node.vm.network :private_network, ip: "11.11.11.11"
    node.hostmanager.aliases = %w(vagrant.rails.dev)
  end

  config.ssh.forward_agent = true

  config.vm.synced_folder "../../src", "/home/vagrant/src"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    # allow symlinks in vm
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]

    vb.customize ["modifyvm", :id, "--cpus", 1]

  end

  config.vm.provider  :vmware_fusion do |vb|
    vb.vmx["numvcpus"] = "1"
    vb.vmx["memsize"] = "1024"
  end

  config.vm.provision :puppet do |puppet|
    puppet.options = "--verbose --debug"
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
    puppet.hiera_config_path = "puppet/hiera.yaml"
  end

end
