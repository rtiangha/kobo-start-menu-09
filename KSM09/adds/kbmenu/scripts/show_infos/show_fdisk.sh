#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
echo "$(date +%Y%m%d_%H%M%S)" > $ksmroot/log/fdisklog
echo "fdisk -l" >> $ksmroot/log/fdisklog
fdisk -l >> $ksmroot/log/fdisklog 
$ksmroot/kbmessage.sh "-f $ksmroot/log/fdisklog"
