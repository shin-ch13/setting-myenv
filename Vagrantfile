# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-6.8"
  #Vitual boxのケーブル接続設定
  config.vm.provider "virtualbox" do |vb|  
   vb.customize ["modifyvm", :id, "--cableconnected1", "on"]  
  end

  config.vm.define "test" do |test|
    #ホスト名の設定
    test.vm.hostname = "test"
    
	#メモリの設定
	# test.customize ["modifyvm", :id, "--memory", "1024"]
    
	#ホストOSと通信するIPアドレスの設定
    test.vm.network "private_network", ip: "192.168.33.12"
  end

  #ansibleの設定
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/main.yml"
    ansible.inventory_path = "provisioning/hosts"
    ansible.limit = 'all'
  end
end
