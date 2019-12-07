#!/bin/sh

### -------------- edit this block: start
#depending on the DB version you may add some more keys in future
UserID=12345678-1234-1234-1234-123456789012
UserKey=87654321-4321-4321-4321-210987654321
UserDisplayName=john.doe@nomail.com
UserEmail=john.doe@nomail.com
___DeviceID=ZG9udCBrbm93Cg==
FacebookAuthToken=
HasMadePurchase=FALSE
IsOneStoreAccount=FALSE
IsChildAccount=FALSE
RefreshToken=
AuthToken=
AuthType=
### -------------- edit this block: end

database=/mnt/onboard/.kobo/KoboReader.sqlite
ksmroot=${ksmroot:-"/adds/kbmenu"}
sqliteprog=$ksmroot/tools/sqlite3

if [ ! -f "$database" ]; then
  echo "Error:_Cannot_find_database"
  exit;
fi

usercols=$($sqliteprog $database 'PRAGMA table_info(user)')

keys=
SAVEIFS=$IFS
IFS=$'\n'
for line in $usercols
do
  keys="$keys $(echo $line | awk -F"|" '{print $2}')"
done
IFS=$SAVEIFS

usercount=$($sqliteprog $database 'SELECT COUNT(*) FROM user')
error=$?

case $error in
  0 )
    if [ "$usercount" -lt 2 ]; then
      commandList=""
      for key in $keys
      do
        [ "x$commandList" != "x" ] && commandList="$commandList, "
        value=$( eval "echo \$$key" )
        commandList="$commandList '${value}'"
      done
      commandList="INSERT INTO user VALUES ("${commandList}");"
      $sqliteprog $database "$commandList"
      message="The_device_is_now_activated."
    else
      message="The_device_was_already_activated."
    fi
    ;;
  *)
   message="There_occured_an_error_the_exit code_was:$error"
    ;;
esac;

echo "$message"
