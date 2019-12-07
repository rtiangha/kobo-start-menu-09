#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
mount > $ksmroot/log/mountlog
$ksmroot/kbmessage.sh "-f $ksmroot/log/mountlog"
