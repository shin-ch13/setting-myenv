# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #boxの指定
  #inline shellの指定
  #config.vm.box = "centos/6"
  #config.vm.provision :shell, inline: $script1
  #config.vm.box = "centos/7"
  #config.vm.provision :shell, inline: $script1
  config.vm.box = "ubuntu/xenial64"
  config.vm.provision :shell, inline: $script2
  
  #Vitual boxのケーブル接続設定
  config.vm.provider "virtualbox" do |vb|  
   vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end

  #エラーの詳細表示(トラッシュ用)
  #config.vm.provider "virtualbox" do |vb|
  #  vb.gui = true
  #end

  config.vm.define "test" do |test|
    #ホスト名の設定
    test.vm.hostname = "test"
	  
    #メモリの設定
	  #test.customize ["modifyvm", :id, "--memory", "1024"]
	  
    #ホストオンリーアダプター
    #静的IPアドレスの割り当て
    test.vm.network "private_network", ip: "192.168.33.12"
    #動的IPアドレスを割当
    #test.vm.network "private_network", type: "dhcp"

    #内部ネットワーク
    #内部ネットワーク名を指定する場合
    #test.vm.network "private_network", ip: "192.168.33.12", virtualbox__intnet: "mynetwork"
    #内部ネットワーク名を指定しない場合
    #test.vm.network "private_network", ip: "192.168.33.12", virtualbox__intnet: true

    #ブリッジアダプター
    #静的IPの割り当て
    #test.vm.network "public_network", ip: "192.168.0.2"
    #DHCPによってIPアドレスを割当
    #test.vm.network "public_network"
    #ブリッジするインターフェースの指定
    #config.vm.network "public_network", bridge: 'en1: Wi-Fi (AirPort)'

    #ポートフォワーディング
    #test.vm.network "forwarded_port", guest: 80, host: 1235

  end

  #vagrant up時にAnsibleを実行する
  #config.vm.provision "ansible" do |ansible|
  #  ansible.playbook = "provisioning/site.yml"
  #  ansible.inventory_path = "provisioning/hosts"
  #  ansible.limit = 'all'
  #end
end

$script1 = <<END
yum update
yum install -y python libselinux-python
END

$script2 = <<END
apt-get update
apt-get install -y python
END
