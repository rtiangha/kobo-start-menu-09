#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
rmcdir=${ksmroot}/rmc

callbbhttpd="busybox httpd -p 8087 -h ${rmcdir}"
the_ip=$(ps | grep "${callbbhttpd}" | grep -v grep)

if [ "x${the_ip}" != "x" ]; then
  echo "rmc_server_is_running"
else
  echo "rmc_server_is_not_running"
fi
