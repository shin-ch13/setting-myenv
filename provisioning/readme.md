# 使い方

1. hostsの"hostname"と"ip address"を対象サーバに変換 
 　　　　os名.childrenの#hostname部分を対象のhostnameに書き換え
2. os名.ymlのuserを対象のユーザ名のに書き換え(defaultはvagrant)
3. roles配下のvim_??とzsh_??のユーザ名部分を書き換え(defaultはvagrant)
4. ansible-playbook --ask-pass site.yml -i hosts -u (ユーザ名) -K
