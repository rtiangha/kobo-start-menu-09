#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
dmesg > $ksmroot/log/dmesglog
$ksmroot/kbmessage.sh "-f $ksmroot/log/dmesglog"
