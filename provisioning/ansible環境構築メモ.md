# ansible環境構築メモ

OSS(オープンソースソフトウェア)のansibleを用いて、仮想環境上に必要なツール(vim,zsh,など)を自動で構成できるようにする。

---------

##開発環境
* OS Ⅹ EL Capitan
* Vitualbox(5.1.0)
* Vagrant(1.9.1)
* ansible(仮想マシンのテンプレート)  
  


##構築例
![]()

---------
##


##1.ansibleのインストール

-----
==**ここ不要でした**==

EPEL(CentOS 標準のリポジトリでは提供されていないパッケージを、yumコマンドでインストールすることを可能にするリポジトリ)のインストールを行う

[https://dl.fedoraproject.org/pub/epel/6/x86_64/](https://dl.fedoraproject.org/pub/epel/6/x86_64/)  
からepel-releaseのリンクをコピー


epel-releaseパッケージの取得

```
$ wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
```

epelリポジトリのインストール

```
sudo rpm -Uvh epel-release-6-8.noarch.rpm
```
-----------



ansibleのインストール

```
$ brew install ansible
```

インストールの確認

```
$ ansible --version
```
##2.Inventoryファイルの作成

Inventoryファイル：ansible処理対象のホスト情報を記述する

```
$ vi hosts
----- 編集開始-----
[A]
192.168.43.52

[B]
192.168.43.53
----- 編集終了-----
```  

ansibleの実行例  
ansible [グループ名] -m [モジュール名] -a ["アクション"]

```
--Inventoryファイルに書かれた対象全てにpingモジュール実行--
$ ansible all -i hosts -m ping

--Aにpingモジュール実行--
$ ansible A -i hosts -m ping
```

実行時にhostの入力を省略するには?

```
$ vi ansible.cfg
----- 編集開始----
[defaults]
hostfile = ./hosts
----- 編集終了----

ansible all -m ping
```

##3.playbookを使う
  
playbook：実行したい処理を記述する

例として、対象ホストにUserを追加する

①普通に書いた場合

```
$ vi playbook.yml
----- 編集開始----
- hosts: all  //対象ホスト
  sudo: yes  //管理者権限
  tasks:  //実行する処理
    - name: add a new user   //処理内容(任意)
      user: name=nobu  //userモジュールからnobuを実行
----- 編集終了----
```

②nobuを変数名で管理

```
$ vi playbook.yml
----- 編集開始----
- hosts: all
  sudo: yes
  vars:
    username: taguchi
  tasks:
    - name: add a new user
      user: name={{username}}
----- 編集終了----
```

③実行時に入力させる

```
$ vi playbook.yml
----- 編集開始----
- hosts: all
  sudo: yes
  vars_prompt:
    username: "Enter username"
  tasks:
    - name: add a new user
      user: name={{username}}
----- 編集終了----
```



実行してみる。。
ansible-playbook [playbookファイル名]

```
$ ansible-playbook playbook.yml

,,,  


完了ならchanged=1とか出る
```


##4.playbookの作成例

公式ドキュメントから必要なモジュールの情報を探す
[http://docs.ansible.com/ansible/modules_by_category.html](http://docs.ansible.com/ansible/modules_by_category.html)

①hosts: webにapacheのインストールとenableの有効化のplaybook

```
$ vi playbook.yml
----- 編集開始----
- hosts: web
  sudo: yes
  tasks:
    - name: install apache
      yum: name=httpd state=latest  //yumモジュールからapacheの最新版(latest)をインストール
    - name: start apache and enabled
      service: name=httpd state=started enabled=yes  //apacheの有効化
----- 編集終了----
```

② (追記)ドキュメント所有者変更とファイルのコピー

```
$ vi playbook.yml
----- 編集開始----
  tasks:
    - name: change owner
      file: dest=/var/www/html owner=vagrant recurse=yes //ファイル所有者変更と以降のディレクトリ所有者も再帰的(recurse=yes)にvagrantにする
    - name: copy index.html
      copy: src=./index.html dest=/var/www/html/index.html owner=vagrant
----- 編集終了----
```

実行後、libselinux-pythonが足りないとエラーが出るので

```
  tasks:
　 　- name: install libselinux-python
    　 yum: name=libselinux-python state=latest
```

を追記する

③(追記)PHPを一括ダウンロード、実行後apacheの再起動

phpがインストール済みだと、apacheの再起動が行われないことに注意

```
$ vi playbook.yml
----- 編集開始----
tasks:
   - name: install php packages
     yum: name={{item}} state=latest
     with_items:
       - php 
       - php-devel
       - php-mbstring
       - php-mysql
     notify:
       - restart apache
 handlers: 
   - name: restart apache
     service: name=httpd state=restarted
----- 編集終了----
```

④(追記)hosts: dbにmysql関連の一括インストールと有効化、データベースの作成とユーザの設定


```
$ vi playbook.yml
----- 編集開始----
- hosts: db
  sudo: yes
  tasks: 
    - name: install mysql
      yum: name={{item}} state=latest
      with_items:
        - mysql-server
        - MySQL-python
    - name: start mysql and enabled
      service: name=mysqld state=started enabled=yes
    - name: create a database
      mysql_db: name=mydb state=present
    - name: create a user for mydb
      mysql_user: name=dbuser password=dbpassword priv=mydb.*:ALL state=present  //(priv=mydb.*:ALL)はmydbの全ての権限を持つ意味
----- 編集終了----
```



##5.(本編)Vagrantホスト(client,server用)のzsh,vim,gitなどのツールを設定するplaybookの作成


[やってみてわかったこと]  

* .ymlは書き方に癖あり。("-"記号は左寄せ、スペースも変なところに入れない)
* libselinux-pythonインストールしなきゃ色々事故る




とりあえずゲストOS起動

```
$ vagrant up
```

--------


Inventoryファイルの作成

```
$ vi hosts
----- 編集開始-----
[server]
192.168.33.10

[client]
192.168.33.11
----- 編集終了-----
```



playbookの作成  
順番に(task:から下)...  
①依存パッケージ(libselinux-pythonを含む。不要なの混じってそう。。)のインストール    
②vimのインストール
③ホストOSの.vimrcをゲストOSにコピー    
④zshのインストール  
⑤ログインシェルをzshにする  
⑥ホストOSの.zshrcをゲストOSにコピー  



```
$ vi playbook-LNP.yml
----- 編集開始----
- hosts: all
  user: vagrant
  sudo: yes
  tasks: 
    - name: requires install
     sudo: true
     yum: name={{ item }} state=present
     with_items:
    - gcc
    - git
    - mercurial
    - ncurses-devel
    - lua
    - lua-devel
    - perl
    - perl-devel
    - perl-ExtUtils-Embed
    - python
    - python-devel
    - libselinux-python

- name: Install vim by yum
  yum: name=vim state=present
     
- name: copy .vimrc file to vagrant home
  copy: src=~/.vimrc dest=~vagrant/.vimrc owner=vagrant group=vagrant mode="u=rw,g=r,o=r"

    
- name: install zsh
  yum: name=zsh state=installed

- name: set zsh as default shell for vagrant user
  command: chsh -s '/bin/zsh' vagrant

- name: copy .zshrc file to vagrant home
  copy: src=~/.zshrc dest=~vagrant/.zshrc owner=vagrant group=vagrant mode="u=rw,g=r,o=r"
----- 編集終了----
```

-------------


これは実はディレクトリで以下のようにまとめられる

├Vagrantfile  
└provisioning   
　├ hosts  
　├ main.yml    
　└ roles  
  　  　├ vim  
    　　　└ tasks  
    　　　　└ main.yml  
    　　├ zsh  
    　　　└ tasks   
    　　　　└ main.yml    　　 　    
   　　  　



各ファイルの中身は以下の通り

provisioning < main.yml

```
---
 # main.yml
 
- hosts: all
  user: vagrant
  sudo: yes
  roles:
    - vim
    - zsh
```

vim < tasks < main.yml

```
- name: requires install
  yum: name={{ item }} state=present
  with_items:
    - gcc
    - git
    - mercurial
    - ncurses-devel
    - lua
    - lua-devel
    - perl
    - perl-devel
    - perl-ExtUtils-Embed
    - python
    - python-devel  
    - libselinux-python

- name: install zsh
  yum: name=zsh state=installed
  
- name: copy .vimrc file to vagrant home
  copy: src=~/.vimrc dest=~vagrant/.vimrc owner=vagrant group=vagrant mode="u=rw,g=r,o=r"
```

zsh < tasks < main.yml

```
- name: install zsh
  yum: name=zsh state=installed

- name: set zsh as default shell for vagrant user
  command: chsh -s '/bin/zsh' vagrant

- name: copy .zshrc file to vagrant home
  copy: src=~/.zshrc dest=~vagrant/.zshrc owner=vagrant group=vagrant mode="u=rw,g=r,o=r"
```


以降、ansibleの実行方法は幾つかある  

①(一般的)Vagrantfileに以下を追記

```
config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/main.yml"
    ansible.inventory_path = "provisioning/hosts"
    ansible.limit = 'all'
end
```

`vagrant provision`でansibleが実行される

②ansible-playbook main.yml から実行



##ansible関連コマンド
* `ansible-playbook (playbook名) --syntax-check` playbookの文法の確認  
* `ansible-playbook (playbook名) --list-task` playbookのタスクの一覧確認
* `ansible-playbook (playbook名) --check` playbook実行確認(実際に実行はしない) 


##参考
[http://shifumin.hatenablog.com/entry/2015/08/26/215000](http://shifumin.hatenablog.com/entry/2015/08/26/215000) 
[https://www.tcmobile.jp/dev_blog/devtool/ansibleのplaybookをいい感じに管理したい/](https://www.tcmobile.jp/dev_blog/devtool/ansibleのplaybookをいい感じに管理したい/)
[http://qiita.com/snaka/items/d5a8004afbfe665e1d3a](http://qiita.com/snaka/items/d5a8004afbfe665e1d3a)
