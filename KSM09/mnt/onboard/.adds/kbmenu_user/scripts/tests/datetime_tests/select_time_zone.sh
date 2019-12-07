#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
zonesdir=/etc/zoneinfo
optionlist=

thisdir=$(pwd)
cd $zonesdir
for file in `find . -type f -name "*"`
do
  bar=${file/ /}
  bar=${bar/-/}
  if [ "$file" == "$bar" ]; then
      file=${file/./}
    optionlist="$optionlist $file"
  fi
done
cd $thisdir

infotext="current_zone:"
selectedoption=

while [ "$selectedoption" != "EXIT" ]; do
infotext=$(date +%Z)
infotext=${infotext// /_}
  selectedoption=$($ksmroot/kobomenu -infotext=$infotext -infolines=2 $optionlist return:arrowup.png return_home:arrowup.png -qws)
  case "$selectedoption" in
    return)  selectedoption="EXIT";;
    return_home)
      selectedoption="EXIT"
      echo "return_home"
      ;;
    *)
      ln -sf $zonesdir$selectedoption /etc/localtime
      ;;
  esac
done
