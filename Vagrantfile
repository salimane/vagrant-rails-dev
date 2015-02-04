# -*- mode: ruby -*-
# vi: set ft=ruby :

SETTINGS = {
  hostname: 'vagrant.rails.com',
  domain: 'local.rails.com',
  ip: '11.11.11.11',
  numvcpus: '4',
  memsize: '4096',
  root_volume_size: 60, # GB
  swap_volume_size: 4, # GB
  diskpath: './disk.vdi',
  box: 'spantree/Centos-6.5_x86-64'
}
Vagrant.require_version '>= 1.7.2'
VAGRANTFILE_API_VERSION = '2'

needs_restart = false
plugins = {
  'vagrant-bindfs' => '0.4.0',
  'vagrant-hostmanager' => '1.5.0'
}
plugins.each do |plugin, version|
  unless Vagrant.has_plugin?(plugin)
    system("vagrant plugin install #{plugin} --plugin-version #{version}") || exit!
    needs_restart = true
  end
  exit system('vagrant', *ARGV) if needs_restart
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = SETTINGS[:box]
  config.vm.box_check_update = true

  config.vm.hostname = SETTINGS[:hostname]

  config.vm.network :private_network, ip: SETTINGS[:ip]
  # config.vm.network :forwarded_port, guest: 3000, host: 80

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.vm.define SETTINGS[:hostname] do |node|
    node.hostmanager.aliases = [SETTINGS[:domain]]
    node.vm.hostname = SETTINGS[:hostname]
    node.vm.network :private_network, ip: SETTINGS[:ip]
    # node.vm.network :forwarded_port, guest: 3000, host: 80
  end

  config.ssh.forward_agent = true
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  config.vm.synced_folder '../', '/home/vagrant/src', type: 'nfs'
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  file_to_disk = SETTINGS[:diskpath]

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ['modifyvm', :id, '--cpus', SETTINGS[:numvcpus]]
    vb.customize ['modifyvm', :id, '--memory', SETTINGS[:memsize]]

    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
    vb.customize ['modifyvm', :id, '--cpuhotplug', 'on']
    vb.customize ['modifyvm', :id, '--cpuexecutioncap', 85]
    vb.customize ['modifyvm', :id, '--pae', 'on']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
    vb.customize ['modifyvm', :id, '--acpi', 'off']
    vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
    vb.customize ['modifyvm', :id, '--vrde', 'off']
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]

    vb.customize ['setextradata', :id, 'VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled', '1']
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root', '1']

    # FIXME: Find/Create a base box with a larger drive
    # The CentOS image has insufficient space, so lets add
    # another drive until we create a new box.
    second_disk_size = SETTINGS[:root_volume_size] + SETTINGS[:swap_volume_size] - 19
    if ARGV[0] == 'up' && !File.exist?(file_to_disk) && SETTINGS[:root_volume_size] > 20
      puts "Creating #{second_disk_size}GB disk #{file_to_disk}."
      vb.customize [
        'createhd',
        '--filename', file_to_disk,
        '--format', 'VDI',
        '--size', (second_disk_size) * 1024 # GB. base image has 20GB
      ]
      vb.customize [
        'storageattach', :id,
        '--storagectl', 'SATA Controller',
        '--port', 1, '--device', 0,
        '--type', 'hdd', '--medium',
        file_to_disk
      ]
    end
  end

  config.vm.provider :vmware_fusion do |vb|
    vb.vmx['numvcpus'] = SETTINGS[:numvcpus]
    vb.vmx['memsize'] = SETTINGS[:memsize]
  end

  if SETTINGS[:root_volume_size] > 20
    # Run script to map new disk
    config.vm.provision :shell, path: 'scripts/add_new_disk.sh', :args => "#{SETTINGS[:root_volume_size]} #{SETTINGS[:swap_volume_size]}"
  end

  # Update puppet to the latest version before using puppet provisioning.
  config.vm.provision :shell, path: 'scripts/update_packages.sh'

  config.vm.provision :puppet do |puppet|
    # puppet.options = '--verbose --debug'
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.synced_folder_type = 'nfs'
    puppet.manifest_file  = 'site.pp'
    puppet.hiera_config_path = 'puppet/hiera.yaml'
  end

end
