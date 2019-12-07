#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
handleWifiAfterKOReader=${handleWifiAfterKOReader:-"ask_the_user"}


[ "$koreaderbasedir" == "" ] && exit
koreadersh=$koreaderbasedir/koreader/koreader.sh


frontlightprg=$ksmroot/tools/frontlight
dontTamperwithFrontlight=${dontTamperwithFrontlight:-"true"}

if [ $(grep -c 'from_nickel' "$koreadersh") -gt 0 ]; then
  if [ $(grep -c  'KOREADER_DIR=/mnt/onboard/.kobo/koreader' $koreadersh) -gt 0 ]; then
    sed -i "s:KOREADER_DIR=/mnt/onboard/.kobo/koreader:KOREADER_DIR=\$(dirname \$0):" $koreadersh
  fi
  if [ $(grep -c  'cd /mnt/onboard/.kobo' $koreadersh) -gt 0 ]; then
    sed -i "s:cd /mnt/onboard/.kobo:cd \$(dirname \$KOREADER_DIR):" $koreadersh
  fi

  if [ "$PRODUCT" == "snow" ]; then
    koreaderrotate=2
  else
    koreaderrotate=${ksmrotate}
  fi
  if [ "${koreaderrotate}" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
    echo "${koreaderrotate}" > /sys/class/graphics/fb0/rotate
    if [ "${koreaderrotate}" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
      echo "$((koreaderrotate ^ 2))" > /sys/class/graphics/fb0/rotate
    fi
  fi

  $koreadersh

  if [ $? -ne 0 ]; then
    echo "koreader exited spontaneously: $(date +%Y%m%d_%H%M%S)" >> $ksmroot/log/koreader_exit_log.txt
    selection=$($ksmroot/kobomenu.sh -autoselectafter=20  -autoselectoption=power_off -infolines=3 "-infotext=KOReader_exited_irregularly" power_off continue)
    if [ ${selection} == "power_off" ]; then
      sync
      $ksmroot/onstart/poweroff.sh
    fi
  fi

else
# remain compatible with older versions of Koreader
  export LC_ALL="en_US.UTF-8"

# we're always starting from our working directory
  cd $koreaderbasedir/koreader/

# export trained OCR data directory
  export TESSDATA_PREFIX="data"

# export dict directory
  export STARDICT_DATA_DIR="data/dict"
# finally call reader
  ./reader.lua /mnt/onboard 2> crash.log
fi

if [ "$deleteSDRsOnboard" == "true" ]; then
  $ksmroot/scripts_intern/koreader/delete_sdrs.sh
fi

#set frontlight for KSM
[ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && [ $PRODUCT != pika ] && (
$frontlightprg "$KSMfrontlightlevel"
)

$ksmroot/onstart/clean_up_after_koreader.sh


if [ "${handleWifiAfterKOReader}" != "leave_alone" ]; then
  if [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ]; then
    case ${handleWifiAfterKOReader} in
      ask_the_user )
        switchoffselection=$($ksmroot/kobomenu.sh -infolines=1 -infotext="Switch_off_wifi?" "yes no")
        case $switchoffselection in
          yes )
            $ksmroot/scripts_intern/wifi/wifi_disable.sh;;
        esac
        ;;
      switch_off )
        $ksmroot/scripts_intern/wifi/wifi_disable.sh;;
    esac
  else
    case ${handleWifiAfterKOReader} in
      switch_on )
        $ksmroot/scripts_intern/wifi/wifi_enable_dhcp.sh;;
    esac
  fi
fi
