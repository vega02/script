cd ~
if [ ! -d $HOME"/package" ]
then
 echo "~/package/ not exists, make one"
 mkdir ~/package
fi
cd ~
echo '
export PS1="\[\033[1;31m\]\u@\h:\w\$ \[\033[0m\]"
alias ls="ls \$LS_OPTIONS -A"
alias ll="ls \$LS_OPTIONS -lA"
alias l="ls \$LS_OPTIONS -lA"
alias h="cd ~; ll"
alias u="cd .."
alias aptg="apt-get install"
alias aptr="apt-get remove"
alias aptpr="apt autoremove --purge"
alias aptu="apt-get update"
alias aptc="apt-get clean"
alias apts="apt-cache search"
alias n="netstat -antl"
alias df="df -BMB"
alias re="/etc/init.d/postfix restart && /etc/init.d/dovecot restart && /etc/init.d/fail2fan restart"
alias mlog="vi /var/log/mail.log"
alias ipt="iptables -L"
alias temp="cat /sys/class/thermal/thermal_zone*/temp"
TZ="Asia/Taipei"; export TZ
cd ~

alias d="docker"
alias dins="docker inspect"
alias dils="docker image ls"
alias dirm="docker image rm"
alias diclean="docker image prune -f"
alias dirma="docker rmi \$(docker images -f \"dangling=true\" -q)"
alias dls="docker image ls && docker ps -a"
alias dps="docker ps -a --format \"{{.ID}} {{.Names}} ({{.Image}}) [{{.Status}}]\" && docker image ls"
alias dpsp="docker ps -a --format \"{{.ID}} {{.Names}} ({{.Image}}) [{{.Status}}]\n{{.Ports}}\" && docker image ls"
alias drd="docker run -d"
alias dre="systemctl daemon-reload && systemctl restart docker"
alias drit="docker run -it"
alias drm="docker rm -f"
alias drma="docker rm \$(docker ps -a -q)"
alias dexec="docker exec -it"
alias dstop="docker stop "
alias dv="docker volume"
alias dvr="docker volume remove"
alias dvins="docker volume inspect"
alias up="docker-compose up -d"
alias down="docker-compose down"
alias dcbuild="docker-compose build --no-cache"
dbuild() {
        docker build -t "$1" . --no-cache
}
dexec(){
        docker exec -it "$1" bash
}
dsave() {
    local image_name_tag="$1"
    local output_file="$(echo "$image_name_tag" | sed 's/[^a-zA-Z0-9_.-]/_/g')".tar

    docker save "$image_name_tag" > "$output_file"
    echo "Docker image $image_name_tag saved as $output_file"
}
dload() {
    docker load -i "$1"
}
ff() {
    if [ $# -eq 0 ]; then
        echo "Usage: f <search_pattern>"
        return 1
    fi
    find . -type f -iname "*$1*"
}
ft() {
    local search_text="$1"
    if [ -z "$search_text" ]; then
        echo "Usage: grepfiles <search_text>"
        return 1
    fi
    grep -rnH "$search_text" .
}
' >> ~/.bashrc

echo '
colo desert
syntax on
'  >> ~/.vimrc

apt-get install vim ssh ftp ntpdate

cd ~/package
wget https://raw.githubusercontent.com/vega02/script/main/updatetime
