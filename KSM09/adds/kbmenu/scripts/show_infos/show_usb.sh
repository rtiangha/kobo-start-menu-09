#!/bin/sh

showfile=/usr/local/Kobo/udev/usb
ksmroot=${ksmroot:-"/adds/kbmenu"}
$ksmroot/kbmessage.sh "-f $showfile"
