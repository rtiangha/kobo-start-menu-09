#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
the_ip=$(ifconfig usb0 2>/dev/null | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')

[ "x${the_ip}" == "x" ] && the_ip="not_enabled" 
echo "usbnet_ip:_${the_ip}"
