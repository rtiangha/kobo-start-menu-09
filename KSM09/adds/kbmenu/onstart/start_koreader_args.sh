#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}

[ "$koreaderbasedir" == "" ] && exit
koreaderdir=$koreaderbasedir/koreader

frontlightprg=$ksmroot/tools/frontlight
dontTamperwithFrontlight=${dontTamperwithFrontlight:-"true"}

export LC_ALL="en_US.UTF-8"

# we're always starting from our working directory
cd $koreaderdir

# export trained OCR data directory
export TESSDATA_PREFIX="data"

# export dict directory
export STARDICT_DATA_DIR="data/dict"
# finally call reader
./reader.lua "$@" 2> crash.log

if [ "$deleteSDRsOnboard" == "true" ]; then
  $ksmroot/scripts_intern/koreader/delete_sdrs.sh
fi

#set frontlight for KSM
[ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && [ $PRODUCT != pika ] && (
[ "$KSMdebugmode" == "true" ] && echo "reset frontligth to $KSMfrontlightlevel" >> $debug_logfile
$frontlightprg "$KSMfrontlightlevel"
)

$ksmroot/onstart/clean_up_after_koreader.sh
[ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ] &&  $ksmroot/kbmessage.sh "Info: Wifi is enabled!"


