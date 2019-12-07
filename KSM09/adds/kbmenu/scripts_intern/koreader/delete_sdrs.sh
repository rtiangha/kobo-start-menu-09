#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
historydir="$koreaderbasedir/koreader/history"

if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "script path: $0" >> $debug_logfile
  echo "ksmroot: $ksmroot" >> $debug_logfile
  echo "historydir: $historydir" >> $debug_logfile
  echo "product: $PRODUCT" >> $debug_logfile
fi

SAVEIFS=$IFS
IFS=$'\n'

for f in $(find $historydir -type f -name '[#*.lua')
do
  histname=$(basename $f)
  [ "$KSMdebugmode" == "true" ] && echo "histname: $histname" >> $debug_logfile
  location=$(echo $histname | awk -F"#] " '{print substr($1,2)}')
  [ "$KSMdebugmode" == "true" ] && echo "location: $location" >> $debug_logfile
  location=$(echo $location | awk '{gsub(/#/, "/", $0); print}')
  case $location in
    /mnt/sd* )
      ;;
    * )
      [ "$KSMdebugmode" == "true" ] && echo "location: $location" >> $debug_logfile
      title=$(echo $histname | awk -F"#] " '{print $2}')
      [ "$KSMdebugmode" == "true" ] && echo "title: $title" >> $debug_logfile
            sdrfolder=${title%.lua}
      sdrfolder=${sdrfolder%.*}.sdr
      [ "$KSMdebugmode" == "true" ] && echo "sdrfolder: $sdrfolder" >> $debug_logfile
      if [ "$location" != "" ] && [ "$sdrfolder" != "" ]; then
        rm -rf "$location/$sdrfolder"
        [ "$KSMdebugmode" == "true" ] && echo "executed: rm -rf $location/$sdrfolder" >> $debug_logfile
      fi
      ;;
  esac
done


[ "$KSMdebugmode" == "true" ] && echo "leaving" >> $debug_logfile
