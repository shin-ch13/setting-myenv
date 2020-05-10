# setting-myenv

# Image

# Requirement

```
% VBoxManage -v
6.1.6r137129
```

```
% vagrant -v
Vagrant 2.2.7
```

```
% ansible --version
ansible 2.9.7
```

# Installation

```
git clone https://github.com/shin-ch13/setting-myenv
cd setting-myenv
```

# Usage

## 1. dotfilesによるローカルマシンの設定

.vimrc , .zshrc , .tmux.conf のシンボリックリンク設定  
※対象パッケージはインストールされていること前提  

```
cd dotfiles
sh ./setup.sh
```

## 2. ansibleによるリモートマシンの設定

イベントリファイル記載のホストに対してPlaybookの実行

```
cd provisioning
sh ./ansible_executable.sh
```

## 3. vagrant+ansibleによるMyテスト環境のデプロイ

仮想マシンのOS選択　　 

```
vim Vagrantfile
```

対象のboxとその下１行をアンコメント　　 

```Vagrantfile
~~~~~~~~~~~~~~~~~~~~~~~~~
  #boxの指定
  #inline shellの指定
  #config.vm.box = "centos/6"
  #config.vm.provision :shell, inline: $script1
  #config.vm.box = "centos/7"
  #config.vm.provision :shell, inline: $script1
  #config.vm.box = "ubuntu/xenial64"
  #config.vm.provision :shell, inline: $script2
~~~~~~~~~~~~~~~~~~~~~~~~~
```

仮想マシンのデプロイ＆ansible実行  
※仮想マシンが起動した後にansibleが自動で実行される  

```
vagrant up
```

