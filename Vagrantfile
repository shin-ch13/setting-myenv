# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"

# Make sure the vagrant plugin is installed
required_plugins = %w(vagrant-vbguest)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

# Defaults for config options defined in CONFIG
$num_instances = 1
$instance_name_prefix = "test"
$enable_serial_logging = false
$share_home = false
$vm_gui = false
$vm_memory = 1024
$vm_cpus = 1
# $vm_box = "centos/6"
# $vm_box = "centos/7"
# $vm_box = "ubuntu/xenial64"
$vm_box = "ubuntu/bionic64"
$vb_cpuexecutioncap = 100
$shared_folders = {'./share' => '/home/vagrant/share'}
$forwarded_ports = {}

# Script to run on Host OS
system(<<~'SCRIPT')
SCRIPT

# Script to run on CentOS Linux
$centos_script = <<SCRIPT
yum update
yum install -y python libselinux-python
SCRIPT

# Script to run on Ubuntu Linux
$ubuntu_script = <<SCRIPT
apt-get update
apt-get install -y python
SCRIPT

# Use old vb_xxx config variables when set
def vm_gui
  $vb_gui.nil? ? $vm_gui : $vb_gui
end

def vm_memory
  $vb_memory.nil? ? $vm_memory : $vb_memory
end

def vm_cpus
  $vb_cpus.nil? ? $vm_cpus : $vb_cpus
end

Vagrant.configure("2") do |config|
  # always use Vagrants insecure key
  config.ssh.insert_key = false
  # forward ssh agent to easily ssh into the different machines
  config.ssh.forward_agent = true
  
  config.vm.box = $vm_box
  #config.vm.provision :shell, inline: $centos_script
  config.vm.provision :shell, inline: $ubuntu_script
  
  # Run Ansible from the Vagrant Host
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/site.yml"
    #ansible.inventory_path = "provisioning/provisioning/inventory/inventory.ini"
    ansible.limit = 'all'
  end
  
  config.vm.provider "virtualbox" do |vb|  
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    #vb.check_guest_additions = false
    #vb.functional_vboxsf     = false
  end

  # plugin conflict
  #if Vagrant.has_plugin?("vagrant-vbguest") then
  #  config.vbguest.auto_update = false
  #end
  
  (1..$num_instances).each do |i|
    config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |config|
      config.vm.hostname = vm_name
  
      if $enable_serial_logging
        logdir = File.join(File.dirname(__FILE__), "log")
        FileUtils.mkdir_p(logdir)

        serialFile = File.join(logdir, "%s-serial.txt" % vm_name)
        FileUtils.touch(serialFile)

        config.vm.provider :virtualbox do |vb, override|
          vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
          vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
        end
      end
      
      config.vm.provider :virtualbox do |vb|
        vb.gui = vm_gui
        vb.memory = vm_memory
        vb.cpus = vm_cpus
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{$vb_cpuexecutioncap}"]
      end

      # mac os ip range limited
      # https://www.virtualbox.org/manual/ch06.html#network_hostonly
      ip = "192.168.56.#{i+100}"
      config.vm.network :private_network, ip: ip

      ## Private Networks
      ## https://www.vagrantup.com/docs/networking/private_network.html
      # 1. Host-Only adapter (not connect VM<--->VM) 
      # Assing Static IP Address (netmask default 255.255.255.0)
      #config.vm.network "private_network", ip: "192.168.33.12"
      #config.vm.network "private_network", ip: "192.168.33.12", netmask: "255.255.255.0"
      # Assing Dynamic IP Addreess using DHCP
      #config.vm.network "private_network", type: "dhcp"
      # Assign Static IPv6 Address (netmask default 64)
      #config.vm.network "private_network", ip: "fde4:8dba:82e1::c4"
      #config.vm.network "private_network", ip: "fde4:8dba:82e1::c4", netmask: "96"

      # 2. Internal Networks (not connect Local machine <----> VM)
      # Create Named Network and Assing Static IP Address
      #config.vm.network "private_network", ip: "192.168.33.12", virtualbox__intnet: "mynetwork"
      # Create not Named Network and Assing Static IP Address
      #config.vm.network "private_network", ip: "192.168.33.12", virtualbox__intnet: true

      ## Public Networks 
      ## https://www.vagrantup.com/docs/networking/public_network.html
      # 1. Bridge Adapter (Connect LAN Directly)
      # Assign Static IP Address 
      #config.vm.network "public_network", ip: "192.168.0.2"
      # Assing Dynamic IP Addreess using DHCP
      #config.vm.network "public_network"
      # Assign IP Address and Specify Network Interface 
      #config.vm.network "public_network", bridge: "en0"
      #config.vm.network "public_network", ip: "192.168.0.10", bridge: "en0"
     
      $forwarded_ports.each do |guest, host|
        config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
      end
      
      # Uncomment below to enable NFS for sharing the host machine into the vagrant VM.
      #config.vm.synced_folder ".", "/home/vagrant/share", id: "vm", :nfs => true, :mount_options => ['nolock,vers=3,udp']
      $shared_folders.each_with_index do |(host_folder, guest_folder), index|
        config.vm.synced_folder host_folder.to_s, guest_folder.to_s, id: "#{$instance_name_prefix}-share%02d" % index, nfs: true, mount_options: ['nolock,vers=3,udp']
      end

      if $share_home
        config.vm.synced_folder ENV['HOME'], ENV['HOME'], id: "home", :nfs => true, :mount_options => ['nolock,vers=3,udp']
      end
    end
  end
end
