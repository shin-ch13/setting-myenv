# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-6.8"
  config.vm.provider "virtualbox" do |vb|  
   vb.customize ["modifyvm", :id, "--cableconnected1", "on"]  
  end

  config.vm.define "test" do |test|
    test.vm.hostname = "test"
    test.vm.network "private_network", ip: "192.168.33.12"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/main.yml"
    ansible.inventory_path = "provisioning/hosts"
    ansible.limit = 'all'
  end
end
