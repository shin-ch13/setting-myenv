#!/bin/sh
vi ./inventory/inventory.ini
vi ./roles/zsh_ubuntu/tasks/main.yml
vi ./roles/zsh_centos/tasks/main.yml

while true; do
    read -p 'Do you want to run the ansible?[y/n]' yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) exit;;
        * ) echo "[y/n]で入力してください";;
    esac
done
ansible-playbook site.yml -i ./inventory/inventory.ini -u nobu --ask-pass --ask-become-pass
