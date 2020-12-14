#!/bin/bash
# Start a Pyquil Server 

HOST=127.0.0.1
PORT=15011


#
# pre
#
pre()
{
if [[ -x /usr/local/bin/qvm ]]; then
    nohup qvm --server --host $HOST --port $PORT &>$outfile &
    echo "$!" >$outfile.pid
    while ((sec < 5)); do
        sleep 1
        netstat -an | grep -qE "$HOST:$PORT.*LISTEN" && break
        ((sec++))
    done
fi
}


#
# Post
#
post()
{
kill $(cat $outfile.pid 2>/dev/null) &>/dev/null
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

