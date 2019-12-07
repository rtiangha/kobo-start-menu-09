#!/bin/sh

# deletes koreader history files that point to non-existent books, and deletes also the related sdr-folders
# does not delete history files that refer to books on external SD


forreal=true

if [ "$forreal" != "true" ]; then
  testreportfile=/mnt/onboard/ko_del_hist_$(date +%Y%m%d_%H%M%S).log
fi

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

delcounter=0

SAVEIFS=$IFS
IFS=$'\n'

for f in $(find $historydir -type f -name '[#*.lua')
do
  echo "checking: $f" >> $testreportfile
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
      title=${title%.lua}
      [ "$KSMdebugmode" == "true" ] && echo "title: $title" >> $debug_logfile
      if [ ! -f "$location/$title" ]; then
        let ++delcounter
        if [ "$forreal" == "true" ]; then
          rm -f "$f"
        else
          echo "rm -f $f" >> $testreportfile
        fi
        sdrfolder=${title%.*}.sdr
        [ "$KSMdebugmode" == "true" ] && echo "sdrfolder: $sdrfolder" >> $debug_logfile
        if [ "$location" != "" ] && [ "$sdrfolder" != "" ]; then
# There could be other files in this folder. Should I care?
          if [ "$forreal" == "true" ]; then
            rm -rf "$location/$sdrfolder"
          else
            echo "rm -rf $location/$sdrfolder"  >> $testreportfile
          fi
          [ "$KSMdebugmode" == "true" ] && echo "executed: rm -rf $location/$sdrfolder" >> $debug_logfile
        fi
      fi
      ;;
  esac
done

if [ "$forreal" == "true" ]; then
  echo "deleted $delcounter history files"
else
  echo "would have deleted $delcounter history files"
fi
[ "$KSMdebugmode" == "true" ] && echo "leaving" >> $debug_logfile
