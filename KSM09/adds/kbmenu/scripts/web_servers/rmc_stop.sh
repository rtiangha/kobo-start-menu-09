#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
rmcdir=${ksmroot}/rmc

callbbhttpd="busybox httpd -p 8087 -h ${rmcdir}"
the_ip=$(ps | grep "${callbbhttpd}" | grep -v grep)

if [ "x${the_ip}" != "x" ]; then
  kill ${the_ip}
fi
