#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
sqliteprog=$ksmroot/tools/sqlite3
database=/mnt/onboard/.kobo/KoboReader.sqlite

$ksmroot/scripts_intern/div/on-animator.sh &
answer=$($sqliteprog $database "REINDEX;" 2>&1)
ecode=$?
killall on-animator.sh

if [ "$answer" != "" ]; then
  echo "$answer"
else
  echo "exit code: $ecode"
fi
