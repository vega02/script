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
mkdir dovecot
mkdir postfix
mkdir fail2ban
mkdir etc
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/init.sql
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/sqlite.init
wget https://github.com/roundcube/roundcubemail/releases/download/1.6.0/roundcubemail-1.6.0-complete.tar.gz
cd dovecot
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/10-auth.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/10-mail.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/10-master.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/10-ssl.conf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/dovecot-sql.conf.ext
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/auth-sql.conf.ext
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/dovecot/auth-static.conf.ext

cd ../postfix
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/main.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/master.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-alias-maps.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-forwarding-maps.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-mailbox-domains.cf
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/postfix/sqlite-virtual-mailbox-maps.cf

cd ../fail2ban
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/fail2ban/jail.local
cd ../etc
wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/etc/mailname
cd ..

#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/mime_header_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/header_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/body_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/client_checks
#wget https://raw.githubusercontent.com/vega02/script/main/mail.roundcube/rbl_whitelist

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
  && chown vmail:vmail /var/mail/vhosts
#touch /etc/fail2ban/jail.local
#touch /etc/postfix/sqlite-virtual-alias-maps.cf
#touch /etc/postfix/sqlite-virtual-forwarding-maps.cf
#touch /etc/postfix/sqlite-virtual-mailbox-domains.cf
#touch /etc/postfix/sqlite-virtual-mailbox-maps.cf

touch /var/log/mail.log
touch /var/log/syslog
chown 101:4 /var/log/mail.log
chown 101:4 /var/log/syslog

#postfix
mv /etc/postfix/main.cf /etc/postfix/main.cf.old
mv /etc/postfix/master.cf /etc/postfix/master.cf.old
#dovecot
mv /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.old
mv /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.old

cp ./dovecot/dovecot-sql.conf.ext /etc/dovecot/
cp ./dovecot/10-auth.conf /etc/dovecot/conf.d/
cp ./dovecot/10-mail.conf /etc/dovecot/conf.d/
cp ./dovecot/10-master.conf /etc/dovecot/conf.d/
cp ./dovecot/10-ssl.conf /etc/dovecot/conf.d/
cp ./dovecot/auth-sql.conf.ext /etc/dovecot/conf.d/

cp ./postfix/main.cf /etc/postfix/
cp ./postfix/master.cf /etc/postfix/
cp ./postfix/sqlite-virtual-alias-maps.cf /etc/postfix/
cp ./postfix/sqlite-virtual-forwarding-maps.cf /etc/postfix/
cp ./postfix/sqlite-virtual-mailbox-domains.cf /etc/postfix/
cp ./postfix/sqlite-virtual-mailbox-maps.cf /etc/postfix/

cp ./fail2ban/jail.local /etc/fail2ban/
cp ./etc/mailname /etc/

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

tar xvf roundcubemail-1.6.0-complete.tar.gz
cp -r roundcubemail-1.6.0/. /var/www/html/
cp ./roundcube/config.inc.php /var/www/html/config/
chown -R www-data:www-data /var/www/html/.
mkdir /opt/roundcube \
chown -R www-data:www-data /opt/roundcube
rm /app/roundcubemail-1.6.0-complete.tar.gz
rm -R /var/www/html/installer

rsyslogd
/etc/init.d/postfix restart
/etc/init.d/dovecot restart
/etc/init.d/fail2ban restart
/etc/init.d/apache2 restart

cd ..