#!/usr/bin/env sh

apk --update add git bash

sed -i -e 's/\/ash/\/bash/g' /etc/passwd

git clone https://github.com/jkanclerz/data-science-workshops-2021 ~/ds-workshop
mkdir -p /root/bin
echo 'source ~/.bashrc' >> /etc/profile


echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
echo "export MY_IP=`/sbin/ip -4 -o addr show dev eth1| awk '{split($4,a,"/");print a[1]}'`" >> ~/.bashrc
echo 'echo "Your IP address is:  ${MY_IP}"' >> ~/.bashrc