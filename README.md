# setting-myenv
**[用途]**
1. dotfilesによるローカルマシンの設定
2. ansibleによるリモートマシンの設定
3. vagrant+ansibleによるMyテスト環境のデプロイ

## 設定方法

## 共通

```
git clone https://github.com/shin-ch13/setting-myenv
cd setting-myenv
```

## 1. dotfilesによるローカルマシンの設定

.vimrc , .zshrc , .tmux.conf のシンボリックリンク設定  
※対象パッケージはインストールされているものとする　　  
※CentOS6,CentOS7,Ubuntu16.04で動作確認済み　　 

```
cd dotfiles
sh ./setup.sh
```

## 2. ansibleによるリモートマシンの設定

リモートマシンのhostname(IPアドレス)とusernameの設定  
Do you want to run the ansible?[y/n]で'y'と入力してansible実行　　 

```
cd provisioning
sh ./config.sh
```

## 3. vagrant+ansibleによるMyテスト環境のデプロイ

仮想マシンのOS選択　　 

```
vim Vagrantfile
```

対象のboxとその下１行をコメントアウト　　 

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
```

仮想マシンのhostname(192.168.33.12)とusername(vagrant)の設定  
Do you want to run the ansible?[y/n]では'n'と入力してスキップ  

```
cd provisioning
sh ./config.sh
```

仮想マシンのデプロイ＆ansible実行  
※仮想マシンが起動した後にansibleが自動で実行される  

```
vagrant up
```

