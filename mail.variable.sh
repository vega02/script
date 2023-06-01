#!/bin/sh

cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi
cd ~/package

mkdir mail.variable
cd mail.variable
mkdir dovecot
mkdir postfix
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/startup.sh
chmod 755 startup.sh
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/init.sql
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/sqlite/sqlite.init
wget https://github.com/roundcube/roundcubemail/releases/download/1.6.0/roundcubemail-1.6.0-complete.tar.gz

cd dovecot
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/10-master.conf

cd ../postfix
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/main.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/master.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-alias-maps.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-forwarding-maps.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-mailbox-domains.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-mailbox-maps.cf

cd ../roundcube
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/roundcube/config.inc.php

cd ..

apt-get update \
  && ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
  && apt install -y tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && echo "postfix postfix/mailname string example.com" | debconf-set-selections \
  && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
  && apt install -y postfix fail2ban \
  && apt install -y dovecot-core dovecot-imapd dovecot-pop3d procmail \
  && apt install -y sqlite3 postfix-sqlite dovecot-sqlite \
  && apt install -y rsyslog vim net-tools iptables mc wget \
  && apt install -y certbot \
  && groupadd -g 5000 vmail \
  && useradd -u 5000 -g vmail -s /usr/bin/nologin -d /home/vmail -m vmail \
  && mkdir /var/mail/vhosts \
  && chown vmail:vmail /var/mail/vhosts \
  && mkdir /var/mail/sqlite \
  && rm /var/www/html/index.html
  

#postfix
#cp /etc/postfix/main.cf /etc/postfix/main.cf.old
#cp /etc/postfix/master.cf /etc/postfix/master.cf.old
#dovecot
#cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.old
#cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.old

cp ./dovecot/10-master.conf /etc/dovecot/conf.d/

cp ./postfix/main.cf /etc/postfix/
cp ./postfix/master.cf /etc/postfix/
cp ./postfix/sqlite-virtual-alias-maps.cf /etc/postfix/
cp ./postfix/sqlite-virtual-forwarding-maps.cf /etc/postfix/
cp ./postfix/sqlite-virtual-mailbox-domains.cf /etc/postfix/
cp ./postfix/sqlite-virtual-mailbox-maps.cf /etc/postfix/

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

#mailname
sed -i "s|example\.com|${DOMAIN:-default\.com}|g" /etc/mailname
#main.cf
sed -i "s|^mydomain =.*|mydomain = ${DOMAIN:-example.com}|g" /etc/postfix/main.cf
#10-auth.conf
sed -i "s|!include auth-system\.conf\.ext|#!include auth-system\.conf\.ext|g" /etc/dovecot/conf.d/10-auth.conf
sed -i "s|#!include auth-sql\.conf\.ext|!include auth-sql\.conf\.ext|g" /etc/dovecot/conf.d/10-auth.conf
sed -i "s|#disable_plaintext_auth =.*|disable_plaintext_auth = no|g" /etc/dovecot/conf.d/10-auth.conf
#10-mail.conf
sed -i "s|^mail_location =.*|mail_location = maildir:/var/mail/vhosts/%d/%n|g" /etc/dovecot/conf.d/10-mail.conf
#10-ssl.conf
sed -i "s|ssl_cert =.*|ssl_cert = </etc/letsencrypt/live/mail.${DOMAIN:-exmple.com}/fullchain.pem|g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s|ssl_key =.*|ssl_key = </etc/letsencrypt/live/mail.${DOMAIN:-example.com}/privkey.pem|g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s|#ssl_ca =.*|ssl_ca = </etc/letsencrypt/live/mail.${DOMAIN:-example.com}/chain.pem|g" /etc/dovecot/conf.d/10-ssl.conf
#dovecot-sql.conf.ext
sed -i "s|#driver =.*|driver = sqlite|g" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s|#connect =.*|connect = /var/mail/sqlite/mail.db|g" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s|#default_pass_scheme = MD5|default_pass_scheme = MD5|g" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s|#user_query =.*|user_query = SELECT username, password,5000 as uid,5000 as gid FROM users WHERE username= '%n' AND domain ='%d' AND active=1|g" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s|#password_query =.*|password_query = SELECT password FROM users WHERE username='%n' AND domain='%d' AND active=1|g" /etc/dovecot/dovecot-sql.conf.ext
#jail.local
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i "s|#ignoreip =.*|ignoreip = 127\.0\.0\.1/8|g" /etc/fail2ban/jail.local
sed -i "s|bantime =.*|bantime = 1440m|g" /etc/fail2ban/jail.local

#inatall roundcube
apt install -y php php-intl php-dom php-mbstring php-sqlite3
a2enmod ssl
a2ensite default-ssl
#php.ini
sed -i "s|;extension=sqlite3|extension=sqlite3|g" /etc/php/8.1/apache2/php.ini
sed -i "s|;date.timezone =.*|date.timezone = Asia/Taipei|g" /etc/php/8.1/apache2/php.ini
#ports.conf
sed -i "s|Listen 80|#Listen 80|g" /etc/apache2/ports.conf
#default-ssl.conf
sed -i "s|SSLCertificateFile.*|SSLCertificateFile       /etc/letsencrypt/live/mail.${DOMAIN:-example.com}/fullchain.pem|g" /etc/apache2/sites-available/default-ssl.conf
sed -i "s|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/letsencrypt/live/mail.${DOMAIN:-example.com}/privkey.pem|g" /etc/apache2/sites-available/default-ssl.conf

#install roundcube
wget https://github.com/roundcube/roundcubemail/releases/download/1.6.0/roundcubemail-1.6.0-complete.tar.gz
tar xvf roundcubemail-1.6.0-complete.tar.gz
cp -r roundcubemail-1.6.0/. /var/www/html/
cp ./roundcube/config.inc.php /var/www/html/config/
chown -R www-data:www-data /var/www/html/.
mkdir /opt/roundcube \
chown -R www-data:www-data /opt/roundcube
rm /app/roundcubemail-1.6.0-complete.tar.gz
rm -R /var/www/html/installer

#roundcube config.inc.php
sed -i "s|\$config\['imap_host'\] =.*|\$config\['imap_host'\] = 'ssl://mail\.${DOMAIN:-example.com}:993';|g" /var/www/html/config/config.inc.php
sed -i "s|\$config\['smtp_host'\] =.*|\$config\['smtp_host'\] = 'ssl://mail\.${DOMAIN:-example.com}:465';|g" /var/www/html/config/config.inc.php


rsyslogd
/etc/init.d/postfix restart
/etc/init.d/dovecot restart
/etc/init.d/fail2ban restart
/etc/init.d/apache2 restart

cd ..