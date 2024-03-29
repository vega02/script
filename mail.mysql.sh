#!/bin/sh

cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi
cd ~/package

mkdir mail.mysql
cd mail.mysql

wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/init.sql

wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/dovecot-sql.conf.ext
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/10-auth.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/10-mail.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/10-master.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/10-ssl.conf

wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/auth-sql.conf.ext
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/auth-static.conf.ext

wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/main.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/master.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/mysql-email2email.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/mysql-virtual-alias-maps.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/mysql-virtual-mailbox-domains.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/mysql-virtual-mailbox-maps.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/smtpd.conf

wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/saslauthd
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/jail.local
wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/mailname



#wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/mime_header_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/header_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/body_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/client_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.mysql/rbl_whitelist


cd ..

apt-get update

apt-get update \
  && apt install -y rsyslog vim net-tools iptables \
  && echo "postfix postfix/mailname string yourdoamin.com" | debconf-set-selections \
  && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
  && apt install -y postfix fail2ban \
  && apt install -y dovecot-core dovecot-imapd dovecot-pop3d sasl2-bin procmail libsasl2-modules \
  && apt install -y dovecot-mysql dovecot-lmtpd postfix-mysql \
  && /usr/sbin/usermod -a -G sasl postfix \
  && ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
  && apt install -y tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && apt install -y certbot python3-certbot-apache \
  && apt install -y mariadb-server \
  && apt install -y mc \
  && apt install -y certbot python3-certbot-apache \
  && groupadd -g 5000 vmail \
  && useradd -u 5000 -g vmail -s /usr/bin/nologin -d /home/vmail -m vmail \
  && mkdir /var/mail/vhosts \
  && chown vmail:vmail /var/mail/vhosts \
  && touch /etc/postfix/sasl/smtpd.conf \
  && touch /etc/fail2ban/jail.local \
  && touch /etc/postfix/mysql-email2email.cf \
  && touch /etc/postfix/mysql-virtual-alias-maps.cf \
  && touch /etc/postfix/mysql-virtual-mailbox-domains.cf \
  && touch /etc/postfix/mysql-virtual-mailbox-maps.cf \
#postfix
mv /etc/postfix/main.cf /etc/postfix/main.cf.old
mv /etc/postfix/master.cf /etc/postfix/master.cf.old
mv /etc/default/saslauthd /etc/default/saslauthd.old
#dovecot
mv /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.old
mv /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.old

cp ./mail.mysql/dovecot-sql.conf.ext /etc/dovecot/
cp ./mail.mysql/10-auth.conf /etc/dovecot/conf.d/
cp ./mail.mysql/10-mail.conf /etc/dovecot/conf.d/
cp ./mail.mysql/10-master.conf /etc/dovecot/conf.d/
cp ./mail.mysql/10-ssl.conf /etc/dovecot/conf.d/
cp ./mail.mysql/auth-sql.conf.ext /etc/dovecot/conf.d/
cp ./mail.mysql/auth-static.conf.ext /etc/dovecot/conf.d/

cp ./mail.mysql/main.cf /etc/postfix/
cp ./mail.mysql/master.cf /etc/postfix/
cp ./mail.mysql/mysql-email2email.cf /etc/postfix/
cp ./mail.mysql/mysql-virtual-alias-maps.cf /etc/postfix/
cp ./mail.mysql/mysql-virtual-mailbox-domains.cf /etc/postfix/
cp ./mail.mysql/mysql-virtual-mailbox-maps.cf /etc/postfix/
cp ./mail.mysql/smtpd.conf /etc/postfix/sasl/

cp ./mail.mysql/saslauthd /etc/default/
cp ./mail.mysql/jail.local /etc/fail2ban/
#cp ./mail.mysql/mailname /etc/

#cp ./mail.mysql/mime_header_checks /etc/postfix/
#cp ./mail.mysql/header_checks /etc/postfix/
#cp ./mail.mysql/client_checks /etc/postfix/
#cp ./mail.mysql/rbl_whitelist /etc/postfix/
#/usr/sbin/postmap /etc/postfix/rbl_whitelist

/etc/init.d/saslauthd restart
/etc/init.d/postfix restart
/etc/init.d/dovecot restart
/etc/init.d/mariadb start

mysql < ./mail.mysql/init.sql

echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt install -y php
apt install -y phpmyadmin
/etc/init.d/apache2 restart

cd ..