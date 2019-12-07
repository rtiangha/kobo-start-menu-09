#!/bin/sh
nkloopfifo=/tmp/kbmenu/nkloopfifo

[ -p "$nkloopfifo" ] && rm $nkloopfifo
killall fmon

killall nickel sickel adobehost fickel
killall hindenburg 
