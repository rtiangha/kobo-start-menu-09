#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
the_ip=$(ifconfig ${INTERFACE} 2>/dev/null | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')

[ "x${the_ip}" == "x" ] && the_ip="wifi is not enabled" 

$ksmroot/kbmessage.sh "${the_ip}"
