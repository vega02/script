echo "export PS1='\[\033[1;33m\]\u@\h:\w\$ \[\033[0m\]'" >> ~/.bashrc
echo "alias ls='ls \$LS_OPTIONS -A'" >> ~/.bashrc
echo "alias ll='ls \$LS_OPTIONS -lA'" >> ~/.bashrc
echo "alias l='ls \$LS_OPTIONS -lA'" >> ~/.bashrc
echo "alias h='cd ~;ll'" >> ~/.bashrc
echo "alias u='cd ..'" >> ~/.bashrc
echo "alias aptg='apt-get install'" >> ~/.bashrc
echo "alias aptr='apt-get remove'" >> ~/.bashrc
echo "alias aptu='apt-get update'" >> ~/.bashrc
echo "alias aptc='apt-get clean'" >> ~/.bashrc
echo "alias apts='apt-cache search'" >> ~/.bashrc
echo "alias n='netstat -ant'" >> ~/.bashrc
echo "alias df='df -BMB'" >> ~/.bashrc
echo "alias re='/etc/init.d/postfix restart && /etc/init.d/dovecot restart'" >> ~/.bashrc
echo "alias mlog='vi /var/log/mail.log'" >> ~/.bashrc
echo "TZ='Asia/Taipei'; export TZ" >> ~/.bashrc
echo "colo desert" >> ~/.vimrc
echo "syntax on" >> ~/.vimrc