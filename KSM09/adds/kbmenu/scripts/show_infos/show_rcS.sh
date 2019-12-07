#!/bin/sh

showfile=/etc/init.d/rcS
ksmroot=${ksmroot:-"/adds/kbmenu"}
$ksmroot/kbmessage.sh "-f $showfile"
