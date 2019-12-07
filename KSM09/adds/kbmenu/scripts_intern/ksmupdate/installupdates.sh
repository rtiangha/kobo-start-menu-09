
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}


if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "script path: $0" >> $debug_logfile
  echo "ksmroot (inherited): $ksmroot" >> $debug_logfile
  echo "product: $PRODUCT" >> $debug_logfile
  echo "ksmGeometryValuesN: $ksmGeometryValuesN"  >> $debug_logfile
  echo "ksmGeometryValuesE: $ksmGeometryValuesE"  >> $debug_logfile
  echo "ksmGeometryValuesS: $ksmGeometryValuesS"  >> $debug_logfile
  echo "ksmGeometryValuesW: $ksmGeometryValuesW"  >> $debug_logfile
  sync
fi

export updatepath=$ksmuser
updatemanagerpath=$ksmroot/scripts_intern/ksmupdate

SAVEIFS=$IFS
IFS=$'\n'
for file in $(find $updatepath -maxdepth 1 -type f -name 'KSM*.zip')
do
  bar=${file/ /}
  if [ "$file" == "$bar" ]; then
    filename=$(basename $file)
    filelist="$filelist ${filename}"
  fi
done
IFS=$SAVEIFS

if [ "x$filelist" != "x" ]; then
  filelist=$(echo $filelist | xargs -n1 | sort | xargs)
  $ksmroot/scripts_intern/div/on-animator.sh &
else
  echo "there are not KSM update files in $ksmuser"
  exit
fi

message=
somethinginstalled=false
for f in $filelist
do
  fullname="$f"
  isready=$($updatemanagerpath/ready_for_update.sh "$updatepath/$fullname")
#echo "$f: $isready"
  if [ "$isready" == "ok" ]; then
    export  fullname
    $updatemanagerpath/runcommands.sh "$updatepath/$fullname" "dobefore"
    applyresponse=$($updatemanagerpath/applyKSMpackage.sh "$updatepath/$fullname")
    $updatemanagerpath/runcommands.sh "$updatepath/$fullname" "doafter"
    if [ "${applyresponse:0:5}" != "ERROR" ]; then
      rm -f "$updatepath/$fullname"
      somethinginstalled=true
    fi
    message="$message<br><b>$fullname</b> $applyresponse"
  else
    message="$message $f: $isready"
  fi
done

[ "$somethinginstalled" == "true" ] && message="$message<br><hr>Tap on the middle of the screen and then press CLOSE. The device will reboot.<br>Or wait until the device restarts automatically after 30 seconds or so."

killall on-animator.sh

sleep 2


if [ "x$message" != "x" ]; then
  ( sleep 20; killall kbmessage ) &
  $ksmroot/kbmessage.sh $message
fi

if [ "$somethinginstalled" == "true" ]; then
  sync
  reboot
else
  echo "nothing installed"
fi
