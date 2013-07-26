# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "vagrant-rails-dev"

  #fqdn hostname
  config.vm.hostname = "vagrant-rails-dev"

  #config.ssh.username = "vagrant"
  #config.ssh.host = ""
  #config.ssh.port = '22'
  #config.ssh.private_key_path
  config.ssh.forward_agent = true

  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-1204-x64.box"

  # config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.network :private_network, ip: "10.10.10.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    # allow symlinks in vm
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]

  end

  config.vm.provision :puppet do |puppet|
    puppet.options = "--verbose --summarize --debug"
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "init.pp"
  end

end
