#!/bin/sh
read -p "Please hostname: " hostname
find ./hosts ./config.sh -type f -print0 | xargs -0 sed -i '' -e "s/XXX/$hostname/g"
read -p "Please username: " username
find . -type f -print0 | xargs -0 sed -i '' -e "s/vagrant/$username/g"
while true; do
    read -p 'Do you want to run the ansible?[y/n]' yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) exit;;
        * ) echo "[y/n]で入力してください";;
    esac
done

ansible-playbook --ask-pass site.yml -i hosts -u $username -K
