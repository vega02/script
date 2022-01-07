#!/bin/sh

cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi
cd ~/package

mkdir dkim
cd dkim

apt-get update
apt-get --assume-yes install opendkim opendkim-tools
#Adding user postfix to group opendkim
adduser postfix opendkim
#gen key
#opendkim-genkey -t -b 2048 -s dkim -d domain.com.tw

wget https://raw.githubusercontent.com/vega02/script/main/opendkim/README
wget https://raw.githubusercontent.com/vega02/script/main/opendkim/opendkim
wget https://raw.githubusercontent.com/vega02/script/main/opendkim/opendkim.conf

#edit add /etc/postfix/main.cf
# DKIM
#milter_default_action = accept
#milter_protocol = 6
#smtpd_milters = inet:localhost:8891
#non_smtpd_milters = inet:localhost:8891
