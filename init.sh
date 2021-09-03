cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi

cd ~
echo "export PS1='\[\033[1;31m\]\u@\h:\w\$ \[\033[0m\]'" >> ~/.bashrc;
echo "alias ls='ls \$LS_OPTIONS -A'" >> ~/.bashrc;
echo "alias ll='ls \$LS_OPTIONS -lA'" >> ~/.bashrc;
echo "alias l='ls \$LS_OPTIONS -lA'" >> ~/.bashrc;
echo "alias h='cd ~;ll'" >> ~/.bashrc;
echo "alias u='cd ..'" >> ~/.bashrc;

echo "alias aptg='apt-get install'" >> ~/.bashrc;
echo "alias aptr='apt-get remove'" >> ~/.bashrc;
echo "alias aptu='apt-get update'" >> ~/.bashrc;
echo "alias aptc='apt-get clean'" >> ~/.bashrc;
echo "alias apts='apt-cache search'" >> ~/.bashrc;
echo "alias n='netstat -antl'" >> ~/.bashrc;
echo "alias df='df -BMB'" >> ~/.bashrc;
echo "TZ='Asia/Taipei'; export TZ" >> ~/.bashrc;
echo "cd ~"

echo "colo desert" >> ~/.vimrc
echo "syntax on" >> ~/.vimrc

apt-get install vim ssh ftp ntpdate

cd ~/package
wget https://raw.githubusercontent.com/vega02/script/main/updatetime
