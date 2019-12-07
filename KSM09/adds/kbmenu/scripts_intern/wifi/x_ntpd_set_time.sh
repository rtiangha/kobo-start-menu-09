#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
#timeserver=pool.ntp.org
timeserver=193.219.61.110

ntpd -q -p ${timeserver} 2>/dev/null
theexitcode="$?"
if [ "$theexitcode" -ne "0" ]; then
  $ksmroot/kbmessage.sh "exit_code:_$theexitcode"
else
  #wait for new time value to be available
  sleep 10
  hwclock -w -u
  infotext=$(hwclock)
  infotext=${infotext// /_}
  $ksmroot/kbmessage.sh "$infotext"
fi


