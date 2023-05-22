#!/bin/sh

cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi
cd ~/package

mkdir mail.roundcube
cd mail.roundcube

#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/init.sql
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/sqlite.init

wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/10-auth.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/10-mail.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/10-master.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/10-ssl.conf

wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot-sql.conf.ext
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/auth-sql.conf.ext
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/auth-static.conf.ext

wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/main.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/master.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/mysql-email2email.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/mysql-virtual-alias-maps.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/mysql-virtual-mailbox-domains.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/mysql-virtual-mailbox-maps.cf

wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/jail.local
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/mailname


#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/mime_header_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/header_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/body_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/client_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/rbl_whitelist

cd ..

apt-get update \
  && apt install -y rsyslog vim net-tools iptables \
  && echo "postfix postfix/mailname string yourdoamin.com" | debconf-set-selections \
  && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
  && apt install -y postfix fail2ban \
  && apt install -y dovecot-core dovecot-imapd dovecot-pop3d procmail \
  && apt install -y sqlite3 postfix-sqlite dovecot-sqlite \
  && ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
  && apt install -y tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && apt install -y certbot python3-certbot-apache \
  && apt install -y mc \
  && apt install -y certbot python3-certbot-apache \
  && groupadd -g 5000 vmail \
  && useradd -u 5000 -g vmail -s /usr/bin/nologin -d /home/vmail -m vmail \
  && mkdir /var/mail/vhosts \
  && chown vmail:vmail /var/mail/vhosts \
  && touch /etc/fail2ban/jail.local \
  && touch /etc/postfix/mysql-virtual-alias-maps.cf \
  && touch /etc/postfix/mysql-virtual-mailbox-domains.cf \
  && touch /etc/postfix/mysql-virtual-mailbox-maps.cf \
#postfix
mv /etc/postfix/main.cf /etc/postfix/main.cf.old
mv /etc/postfix/master.cf /etc/postfix/master.cf.old
#dovecot
mv /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.old
mv /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.old

cp ./mail.roundcube/dovecot-sql.conf.ext /etc/dovecot/
cp ./mail.roundcube/10-auth.conf /etc/dovecot/conf.d/
cp ./mail.roundcube/10-mail.conf /etc/dovecot/conf.d/
cp ./mail.roundcube/10-master.conf /etc/dovecot/conf.d/
cp ./mail.roundcube/10-ssl.conf /etc/dovecot/conf.d/
cp ./mail.roundcube/auth-sql.conf.ext /etc/dovecot/conf.d/
cp ./mail.roundcube/auth-static.conf.ext /etc/dovecot/conf.d/

cp ./mail.roundcube/main.cf /etc/postfix/
cp ./mail.roundcube/master.cf /etc/postfix/
cp ./mail.roundcube/mysql-virtual-alias-maps.cf /etc/postfix/
cp ./mail.roundcube/mysql-virtual-mailbox-domains.cf /etc/postfix/
cp ./mail.roundcube/mysql-virtual-mailbox-maps.cf /etc/postfix/

cp ./mail.roundcube/jail.local /etc/fail2ban/
cp ./mail.roundcube/mailname /etc/

#cp ./mail.roundcube/mime_header_checks /etc/postfix/
#cp ./mail.roundcube/header_checks /etc/postfix/
#cp ./mail.roundcube/client_checks /etc/postfix/
#cp ./mail.roundcube/rbl_whitelist /etc/postfix/
#/usr/sbin/postmap /etc/postfix/rbl_whitelist



#/etc/init.d/mariadb start

#mysql < ./mail.roundcube/init.sql
#sqlite3 dovecot.db < sqlite.init

echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt install -y php php-intl php-dom php-mbstring php-sqlite3
#apt install -y phpmyadmin

/etc/init.d/postfix restart
/etc/init.d/dovecot restart
/etc/init.d/fail2ban restart
/etc/init.d/apache2 restart

cd ..