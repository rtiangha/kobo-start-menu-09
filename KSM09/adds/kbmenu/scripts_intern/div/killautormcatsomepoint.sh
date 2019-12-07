#!/bin/sh

sleep 1m
ksmroot=${ksmroot:-"/adds/kbmenu"}
rmcbasedir=${ksmroot}/rmc

callbbhttpd="busybox httpd -p 8087 -h ${rmcbasedir}"
the_ip=$(ps | grep "${callbbhttpd}" | grep -v grep)

if [ "x${the_ip}" != "x" ]; then
  kill ${the_ip}
fi

if ifconfig | grep -q usb0; then
  ifconfig usb0 down
  rmmod g_ether
  rmmod arcotg_udc
fi

