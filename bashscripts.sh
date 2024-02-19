#!/bin/bash

# COMMON ALIASES

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cpd='cp -Rfv'
alias du+='du max-depth\=1 -x -h'
alias llg='ls -lah | grep'
alias lll='ls -laFtu | less'
alias mesgrep='cat /var/log/syslog | grep'
alias ls='ls --color=auto'
alias mata='kill -9'
alias p='ps axf -o pid,user,cmd'
alias paquete='dpkg -l | grep -i'
alias psg='ps aux | grep'
alias psl='ps aux | less'
alias rmd='rm -Rfv'
alias setgpg='gpg --armor --export  | sudo apt-key add -'
alias t='tail'
alias tf='tail -f'
alias tn='tail -n'
alias tree='find -type d'
alias disco='iostat -xm 1'
alias mystop='watch -n 1 mysqladmin process'
alias mempro='ps -e -orss=,args= | sort -b -k1,1n | pr -TW$COLUMNS'
alias socketing='cat /proc/net/sockstat'
alias mysqlcon='for i in `seq 1 10000`;do echo "Conexiones a Mysql: `mysqladmin process | grep "|" | wc -l`";sleep 2; done'
alias chequeaconntrack='sysctl -a | grep -i conntr | grep -E "(k_count |k_max )"'
alias apti='aptitude install'
alias aptp='aptitude purge'
alias aptr='aptitude remove'
alias apts='aptitude search'
alias aptu='aptitude update'
alias aptup='aptitude upgrade'
alias postgrep="grep postfix /var/log/mail.log | grep -i"
alias dovegrep="grep dovecot /var/log/mail.log | grep -i"
alias mailgrep="cat /var/log/mail.log | grep -i"
alias mailtail="tail -f /var/log/mail.log"
alias mailtailgrep="tail -f /var/log/mail.log | grep -i"
alias reloadcsf="systemctl stop csf;systemctl stop lfd;sleep 5;systemctl start csf;sleep 10;systemctl start lfd"
alias resetcsf="csf -x; sleep 1; csf -e"
alias godomlogs="cd /var/log/ispconfig/httpd"
alias bind9querylog="rndc querylog"
alias clearcachesswap="sync && echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'"
alias modsecanalysis="source /root/scripts/split-modsec-file.sh;/root/scripts/clean-modsec-files.sh;ll"
alias testipv6ping="ping -c 2 -6 www.cyberciti.biz"
alias salirssh='unset HISTFILE && exit'


# COMMON FUNCTIONS

dur(){ find $1 -type f -links 1 -printf "%s\n" | awk '{s=s+$1} END {print s}' | awk  '{ byte =$1/1024/1024/1024; print byte }' | awk '{printf("%.2f\n", $1)}' | xargs -I{} echo "{}G"; }
duh(){ find $1 -type f -links +1 -printf "%s\n" | awk '{s=s+$1} END {print s}' | awk  '{ byte =$1/1024/1024/1024; print byte }' | awk '{printf("%.2f\n", $1)}' | xargs -I{} echo "{}G"; }
durf(){ find $1 -type f -links 1; }
duhf(){ find $1 -type f -links +1; }
chequeacon(){ netstat -an | awk '/tcp/ {print $6}' | sort | uniq -c; }
quienphp(){ psg php | awk '{print $1}' | sort | uniq -c | sort -n; }

reloadphps(){
        for php in $(find /usr/bin/ -maxdepth 1 -mindepth 1 -type f -regextype sed -regex ".*/php[0-9]\.[0-9]" | awk -F"php" '{print $2}' | sort)
        do
                echo "Reloading php${php}-fpm.service"
                systemctl reload php${php}-fpm.service
                sleep 5
        done
        echo "Showing current php processes executing:"
        ps aux | grep "php-fpm: master process"
}
restartphps(){
        for php in $(find /usr/bin/ -maxdepth 1 -mindepth 1 -type f -regextype sed -regex ".*/php[0-9]\.[0-9]" | awk -F"php" '{print $2}' | sort)
        do
                echo "Restarting php${php}-fpm.service"
                systemctl restart php${php}-fpm.service
                sleep 5
        done
        echo "Showing current php processes executing:"
        ps aux | grep "php-fpm: master process"
}

checkcertdns(){
        [[ -z $1 ]] && echo "checkcert <server> <port> <sni_name>"
        server="$1"
        port="$2"
        sni="$3"
        [[ ! -z $1 ]] && openssl s_client -connect ${server}:${port} -servername ${sni} </dev/null 2>/dev/null | openssl x509 -noout -text | grep DNS:
}

checkcert(){
        [[ -z $1 ]] && echo "checkcert <server> <port> <sni_name>"
        server="$1"
        port="$2"
        sni="$3"
        [[ ! -z $1 ]] && openssl s_client -connect ${server}:${port} -servername ${sni} </dev/null 2>/dev/null | openssl x509 -noout -text | grep -A 4 "Issuer:"
}

checkssl(){
        [[ -z $1 ]] && echo "checkcert <server> <port> <sni_name>"
        server="$1"
        port="$2"
        sni="$3"
        [[ ! -z $1 ]] && openssl s_client -connect ${server}:${port} -servername ${sni} </dev/null 2>/dev/null | openssl x509 -noout -text | grep -A 4 "Issuer:"
}

checkfilessl(){
        openssl x509 -text -noout -in $1
}

swap(){
        #smem --sort=swap --reverse --percent
        smem --sort=swap --reverse | head -n 20
}
memory(){
        ps aux --sort -rss | head -n 20
}

learnspam(){
        for file in $(find -maxdepth 1 -mindepth 1 -type f); do cat $file | rspamc learn_spam; done
}

gomail(){
        mail="$(echo $1 | awk -F"@" '{print $1}')"
        domain="$(echo $1 | awk -F"@" '{print $2}')"
        cd /var/vmail/$domain/$mail/Maildir/
}

imunifyrestart(){
        for service in imunify-antivirus-sensor.socket imunify-antivirus.service imunify-antivirus.socket imunify-antivirus-user.socket imunify-notifier.service imunify-notifier.socket
        do
                systemctl stop $service
                systemctl stop $service
                sleep 10
                systemctl start $service
        done
}
