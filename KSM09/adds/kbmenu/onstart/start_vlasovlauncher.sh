#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}

ver=`cat $vlasovsoftbasedir/VERSION`
if [ -z "$ver" ] || [ "$ver" \< "2017.10.18" ]; then
  $ksmroot/kbmessage.sh "unsupported version of launcher"
  exit
fi


case $PRODUCT in
  dragon|dahlia|snow ) vlasovsoftrotate="2";;
  * ) vlasovsoftrotate="0";;
esac
if [ "${vlasovsoftrotate}" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
  echo "${vlasovsoftrotate}" > /sys/class/graphics/fb0/rotate
  if [ "${vlasovsoftrotate}" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
    echo "$((vlasovsoftrotate ^ 2))" > /sys/class/graphics/fb0/rotate
  fi
fi
frontlightprg=$ksmroot/tools/frontlight
dontTamperwithFrontlight=${dontTamperwithFrontlight:-"true"}

# frontligth off
[ "$dontTamperwithFrontlight" == "true" ] && [ "$PRODUCT" != "trilogy" ] && [ "$PRODUCT" != "pixie" ] &&
(
$frontlightprg "0"
[ "$KSMdebugmode" == "true" ] && echo "on start: frontlight level set to 0" >> $debug_logfile
)

# set variables
export ROOT="$vlasovsoftbasedir"
VLASOVSOFT_KSM=1
. $vlasovsoftbasedir/launcher.sh

#set frontlight for KSM
[ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && [ $PRODUCT != pika ] && (
$frontlightprg "$KSMfrontlightlevel"
[ "$KSMdebugmode" == "true" ] && echo "before exit: frontlight level set to $KSMfrontlightlevel" >> $debug_logfile
)

