#!/bin/sh

cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi
cd ~/package

mkdir mail.ssl
cd mail.ssl
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/10-auth.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/10-mail.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/10-ssl.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/dovecot.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/main.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/master.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/smtpd.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.ssl/saslauthd

cd ..

apt-get update

echo "postfix postfix/mailname string ezconn.tw" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt install -y postfix

apt-get install -y dovecot-core dovecot-imapd dovecot-pop3d sasl2-bin procmail libsasl2-modules
apt-get install -y vim net-tools iptables
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
apt-get install -y tzdata
dpkg-reconfigure --frontend noninteractive tzdata

#postfix
mv /etc/postfix/main.cf /etc/postfix/main.cf.old
mv /etc/postfix/master.cf /etc/postfix/master.cf.old
mv /etc/default/saslauthd /etc/default/saslauthd.old
#dovecot
mv /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.old
mv /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.old
mv /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.old

cp ./mail.ssl/main.cf /etc/postfix/
cp ./mail.ssl/master.cf /etc/postfix/
cp ./mail.ssl/smtpd.conf /etc/postfix/sasl/
cp ./mail.ssl/saslauthd /etc/default/saslauthd

cp ./mail.ssl/10-mail.conf /etc/dovecot/conf.d/
cp ./mail.ssl/10-auth.conf /etc/dovecot/conf.d/
cp ./mail.ssl/10-ssl.conf /etc/dovecot/conf.d/

/usr/sbin/usermod -a -G sasl postfix

/etc/init.d/saslauthd restart
/etc/init.d/postfix restart
/etc/init.d/dovecot restart

cd ..
