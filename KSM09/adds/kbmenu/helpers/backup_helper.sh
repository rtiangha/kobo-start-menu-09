if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_backuphelper.log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "ksmroot: $ksmroot" >> $debug_logfile
fi

thisScript=$(readlink -f $0)
if [ "$(basename $thisScript)" == "backup_helper.sh" ]; then
  echo "Do not call this script directly!"
  echo "Find examples of usage in scripts/back_up."
  exit
fi
echo "$sourcefilename"
[ ! -f "$sourcedir/$sourcefilename" ] && $ksmroot/kbmessage.sh "Cannot find $sourcedir/$sourcefilename"


if [ "$showanimation" == "true" ]; then
  export animationDurationS=5
  $ksmroot/scripts_intern/div/on-animator.sh &
fi
[ ! -e $backupdir ] && mkdir -p $backupdir
[ "$addtimestamp" == "true" ] && targetfilebasename="${targetfilebasename}_$timestamp"
if [ "$gzipmode" == "true" ]; then
  targetfilebasename="${targetfilebasename}.gz"
  cd $sourcedir
  gzip -c "$sourcefilename" > "$backupdir/$targetfilebasename" 2>&1
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    response=$(echo "gzip error: exit code $exit_status")
  else
    response=$(echo "extracted  $selectedoption to $targetfile" )
  fi
else
  response=$(cp "$sourcedir/$sourcefilename" "$backupdir/$targetfilebasename" 2>&1)
fi

###
if [ "$showanimation" == "true" ]; then
  killall on-animator.sh
fi

###
[ "$KSMdebugmode" == "true" ] && echo "response: $response" >> $debug_logfile
