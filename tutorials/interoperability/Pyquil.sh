#!/bin/bash
# Start Pyquil Servers

declare -A server_path server_opts server_host server_port server_pidf

servers="qvm quilc"

server_path[qvm]="/usr/local/bin/qvm"
server_opts[qvm]="--server"
server_host[qvm]="127.0.0.1"
server_port[qvm]="15011"
server_pidf[qvm]="${outfile%%.*}_qvm.pid"

server_path[quilc]="/usr/local/bin/quilc"
server_opts[quilc]="--server-mode-rpc"
server_host[quilc]="127.0.0.1"
server_port[quilc]="15012"
server_pidf[quilc]="${outfile%%.*}_quilc.pid"


#
# pre
#
pre()
{
for server in $servers; do
    if [[ -x ${server_path[$server]} ]]; then
        cmd="nohup $server ${server_opts[$server]} --host ${server_host[$server]} --port ${server_port[$server]}"
        echo -e "\n> $cmd" >>$outfile
        eval $cmd &>>$outfile &
        echo "$!" >${server_pidf[$server]}
        while ((sec < 5)); do
            sleep 1
            netstat -an | grep -qE "${server_host[$server]}:${server_port[$server]}.*LISTEN" && break
            ((sec++))
        done
    fi
done
}


#
# Post
#
post()
{
for server in $servers; do
    kill $(cat ${server_pidf[$server]} 2>/dev/null) &>/dev/null
done
return
}


#
# Main
#
snipet=$1
outfile="$2"

case $snipet in
    pre)
        pre
        ;;
    post)
        post
        ;;
esac

