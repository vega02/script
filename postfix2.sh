#!/bin/sh

cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi
cd ~/package

mkdir postfix2
cd postfix2
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/main.cf
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/master.cf
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/smtpd.conf
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/saslauthd
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/mime_header_checks
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/header_checks
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/body_checks
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/client_checks
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/rbl_whitelist
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/10-auth.conf
wget https://raw.githubusercontent.com/vega02/script/main/postfix2/10-mail.conf
cd ..

apt-get update

echo "postfix postfix/mailname string ezconn.tw" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt install -y postfix

apt-get --assume-yes install dovecot-core dovecot-imapd dovecot-pop3d sasl2-bin procmail libsasl2-modules

#postfix
mv /etc/postfix/main.cf /etc/postfix/main.cf.old
mv /etc/postfix/master.cf /etc/postfix/master.cf.old
mv /etc/default/saslauthd /etc/default/saslauthd.old
#dovecot
mv /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.old
mv /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.old

cp ./postfix2/main.cf /etc/postfix/
cp ./postfix2/master.cf /etc/postfix/
cp ./postfix2/smtpd.conf /etc/postfix/sasl/
cp ./postfix2/saslauthd /etc/default/saslauthd
cp ./postfix2/mime_header_checks /etc/postfix/
cp ./postfix2/header_checks /etc/postfix/
cp ./postfix2/client_checks /etc/postfix/
cp ./postfix2/rbl_whitelist /etc/postfix/

cp ./postfix2/10-mail.conf /etc/dovecot/conf.d/
cp ./postfix2/10-auth.conf /etc/dovecot/conf.d/

/usr/sbin/postmap /etc/postfix/rbl_whitelist

/usr/sbin/usermod -a -G sasl postfix

/etc/init.d/saslauthd restart
/etc/init.d/postfix restart
/etc/init.d/dovecot restart

cd ..
