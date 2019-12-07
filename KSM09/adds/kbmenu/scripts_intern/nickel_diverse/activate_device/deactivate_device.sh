#!/bin/sh

database=/mnt/onboard/.kobo/KoboReader.sqlite
ksmroot=${ksmroot:-"/adds/kbmenu"}
sqliteprog=$ksmroot/tools/sqlite3

response=$($sqliteprog $database "DELETE FROM user;")

if [ "$?" == "0" ]; then
  echo "ok!"
else
  echo "$response"
fi
