#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
frontlightprg=$ksmroot/tools/frontlight
dontTamperwithFrontlight=${dontTamperwithFrontlight:-"true"}

if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "product: $PRODUCT" >> $debug_logfile
fi



# frontligth off
[ "$dontTamperwithFrontlight" == "true" ] && [ "$PRODUCT" != "trilogy" ] && [ "$PRODUCT" != "pixie" ] &&
(
$frontlightprg "0"
[ "$KSMdebugmode" == "true" ] && echo "on start: frontlight level set to 0" >> $debug_logfile
)

# set variables
export ROOT="$vlasovsoftbasedir"
cd $ROOT
. ./setvars.sh

# make the temporary directory for Qt
mkdir -p $TMPDIR

# make fifo
mkfifo $VLASOVSOFT_FIFO

# run launcher
if [ "$KSMdebugmode" == "true" ]; then
  echo "----- output of launcher: begin" >> $debug_logfile
  $ROOT/launcher -qws -stylesheet $STYLESHEET >> $debug_logfile 2>&1
  echo "---- output of launcher: end" >> $debug_logfile
else
  $ROOT/launcher -qws -stylesheet $STYLESHEET
fi

# remove fifo
rm $VLASOVSOFT_FIFO

#set frontlight for KSM
[ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && (
$frontlightprg "$KSMfrontlightlevel"
[ "$KSMdebugmode" == "true" ] && echo "before exit: frontlight level set to $KSMfrontlightlevel" >> $debug_logfile
)
