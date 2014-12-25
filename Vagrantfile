# -*- mode: ruby -*-
# vi: set ft=ruby :

SETTINGS = {
  :hostname => 'vagrant.rails.com',
  :domain   => 'local.rails.com',
  :ip       => '11.11.11.11',
  :numvcpus => '4',
  :memsize  => '4096',
  :box      => 'spantree/Centos-6.5_x86-64'
}
Vagrant.require_version ">= 1.7.1"
VAGRANTFILE_API_VERSION = "2"

$puppet_update_script = <<SCRIPT
rpm -qa puppetlabs-release | grep 'puppetlabs-release-6' || rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
rpm -qa epel-release | grep 'epel-release-6' || rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -qa remi-release | grep 'remi-release-6' || rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -qa ruby-devel | grep 'ruby-devel-1.8.7' || yum -y install ruby-devel
rpm -qa ruby-augeas | grep 'ruby-augeas-0.4.1' || yum -y install ruby-augeas-0.4.1
rpm -qa ruby-json | grep 'ruby-json-1.5.5' || yum -y install ruby-json-1.5.5
rpm -qa puppet | grep 'puppet-3.7.3' || yum -y install puppet-3.7.3
rpm -qa augeas-libs | grep 'augeas-libs-1.0.0' || yum -y install augeas-libs-1.0.0
rpm -qa augeas-devel | grep 'augeas-devel-1.0.0' || yum -y install augeas-devel-1.0.0
rpm -qa augeas | grep 'augeas-1.0.0' || yum -y install augeas-1.0.0
gem list | grep 'puppet.*3.7.3' || gem install puppet -v3.7.3
gem list | grep 'ruby-augeas.*0.5.0' || gem install ruby-augeas -v0.5.0
yum update -y
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = SETTINGS[:box]
  config.vm.box_check_update = true

  config.vm.hostname = SETTINGS[:hostname]

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network :private_network, ip: SETTINGS[:ip]
  # config.vm.network "public_network"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.vm.define SETTINGS[:hostname] do |node|
    node.hostmanager.aliases = [SETTINGS[:domain]]
    node.vm.hostname = SETTINGS[:hostname]
    node.vm.network :private_network, ip: SETTINGS[:ip]
  end

  # config.ssh.username = 'vagrant'
  config.ssh.forward_agent = true

  config.vm.synced_folder '../', '/home/vagrant/src', type: 'nfs'
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ['modifyvm', :id, '--memory', SETTINGS[:memsize]]
    # allow symlinks in vm
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]

    vb.customize ['modifyvm', :id, '--cpus', SETTINGS[:numvcpus]]

  end

  config.vm.provider  :vmware_fusion do |vb|
    vb.vmx['numvcpus'] = SETTINGS[:numvcpus]
    vb.vmx['memsize'] = SETTINGS[:memsize]
  end

  # Update puppet to its latest version before using puppet provisioning.
  config.vm.provision :shell, inline: $puppet_update_script

  config.vm.provision :puppet do |puppet|
    # puppet.options = '--verbose --debug'
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.synced_folder_type = "nfs"
    puppet.manifest_file  = 'site.pp'
    puppet.hiera_config_path = 'puppet/hiera.yaml'
  end

end
