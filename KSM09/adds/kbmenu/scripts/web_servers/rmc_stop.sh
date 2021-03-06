#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
rmcdir=${ksmroot}/rmc

#todo
# run a loop to kill all httpd -p 8087
# remove ${rmcdir}, so that each instance of KSM can stop httpd started by another instances of KSM, if there are any

callbbhttpd="busybox httpd -p 8087 -h ${rmcdir}"
the_ip=$(ps | grep "${callbbhttpd}" | grep -v grep)

if [ "x${the_ip}" != "x" ]; then
  kill ${the_ip}
fi
