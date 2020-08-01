#!/bin/sh
vi ./inventory/inventory.ini
while true; do
    read -p 'Do you want to run the ansible?[y/n]' yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) exit;;
        * ) echo "[y/n]で入力してください";;
    esac
done
ansible-playbook site.yml -i ./inventory/inventory.ini -u $username --ask-pass --ask-become-pass
