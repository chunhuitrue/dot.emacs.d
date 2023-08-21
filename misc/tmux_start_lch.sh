#!/bin/sh

server=lch-server
conf=~/.tmux.conf
# conf=/home/lch/.tmux.conf
session=OIO


tmux -L $server -f $conf has-session -t $session
if [ $? != 0 ] 
then
    tmux -L $server -f $conf -u new-session -s $session
fi
tmux -L $server -f $conf -u attach -d -t $session

