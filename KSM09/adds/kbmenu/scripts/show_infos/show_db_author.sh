#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
$ksmroot/tools/sqlite3 /mnt/onboard/.kobo/KoboReader.sqlite 'select Attribution from content where Attribution <> ""' | sort | uniq > $ksmroot/log/dbauthors.txt
$ksmroot/kbmessage.sh "-f $ksmroot/log/dbauthors.txt"
