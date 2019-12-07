#!/bin/busybox sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
rmcdir=${ksmroot}/rmc

callbbhttpd="busybox httpd -p 8087 -h ${rmcdir}"
isrunning=$(ps | grep "${callbbhttpd}" | grep -v grep)
[ "x${isrunning}" == "x" ] || exit

ifconfig lo | grep -q addr:127.0.0.1 || ifconfig lo 127.0.0.1
${callbbhttpd}
