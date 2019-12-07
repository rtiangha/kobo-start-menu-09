#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}

KOREADER_DIR="$1"
[ "$KOREADER_DIR" == "" ] && exit
koreadersh=$KOREADER_DIR/koreader.sh

frontlightprg=$ksmroot/tools/frontlight
dontTamperwithFrontlight=${dontTamperwithFrontlight:-"true"}
currentRotation=$(cat /sys/class/graphics/fb0/rotate)

  if [ "$PRODUCT" == "snow" ]; then
    echo 2 > /sys/class/graphics/fb0/rotate
    cat /sys/class/graphics/fb0/rotate > /sys/class/graphics/fb0/rotate
  fi

if [ $(grep -c 'from_nickel' "$koreadersh") -gt 0 ]; then
  if [ $(grep -c  'KOREADER_DIR=/mnt/onboard/.kobo/koreader' $koreadersh) -gt 0 ]; then
    sed -i "s:KOREADER_DIR=/mnt/onboard/.kobo/koreader:KOREADER_DIR=\$(dirname \$0):" $koreadersh
  fi
  if [ $(grep -c  'cd /mnt/onboard/.kobo' $koreadersh) -gt 0 ]; then
    sed -i "s:cd /mnt/onboard/.kobo:cd \$(dirname \$KOREADER_DIR):" $koreadersh
  fi
  $koreadersh
else
# remain compatible with older versions of Koreader
# we're always starting from our working directory
  cd $KOREADER_DIR

# export trained OCR data directory
  export TESSDATA_PREFIX="data"

  args="/mnt/onboard"

# export dict directory
  export STARDICT_DATA_DIR="data/dict"
  ./reader.lua $args 2> crash.log
fi

  if [ "$PRODUCT" == "snow" ]; then
    echo 0 > /sys/class/graphics/fb0/rotate
    cat /sys/class/graphics/fb0/rotate > /sys/class/graphics/fb0/rotate
  fi
 
#set frontlight for KSM
[ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && [ $PRODUCT != pika ] && (
$frontlightprg "$KSMfrontlightlevel"
)

$ksmroot/onstart/clean_up_after_koreader.sh
[ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ] &&  $ksmroot/kbmessage.sh "Info: Wifi is enabled!"

