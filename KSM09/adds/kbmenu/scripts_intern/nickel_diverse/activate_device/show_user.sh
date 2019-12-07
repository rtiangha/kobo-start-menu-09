#!/bin/sh

database=/mnt/onboard/.kobo/KoboReader.sqlite
ksmroot=${ksmroot:-"/adds/kbmenu"}
sqliteprog=$ksmroot/tools/sqlite3
logfile=/tmp/dbuser.txt

$sqliteprog $database 'select * from user' > $logfile
$ksmroot/kbmessage.sh "-f $logfile"
