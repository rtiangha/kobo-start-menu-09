#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
loopscount=0
the_ip=
while [ "x${the_ip}" == "x" ] && [ ${loopscount} -lt 30 ]; do
  let loopscount++
  sleep 0.5
  #the_ip=$(ifconfig eth0 2>/dev/null | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')
  the_ip=$(ifconfig eth0 2>/dev/null | awk '/inet addr/{print substr($2,6)}')
done

[ "x${the_ip}" == "x" ] && the_ip="was_not_available"
echo "wifi_ip:_${the_ip}"
