#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
logfile=$ksmroot/log/lsofmountlog.txt
echo "$(date +%Y%m%d_%H%M%S)" > $logfile
echo "lsof | grep /mnt" >> $logfile
echo lsof | grep /mnt >> $logfile 
$ksmroot/kbmessage.sh "-f $logfile"
