#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}

frontlightprg=$ksmroot/tools/frontlight
dontTamperwithFrontlight=${dontTamperwithFrontlight:-"true"}
handleWifiAfterNickel=${handleWifiAfter:-"ask_the_user"}

if [ -e /mnt/onboard/.kobo/Kobo.tgz ] || [ -e /mnt/onboard/.kobo/KoboRoot.tgz ]; then
  $ksmroot/kbmessage.sh "Please handle your update files!"
  exit
fi

export clean_up_after_koreader_in_any_case=true

kbmenuonstartdir=$ksmroot/onstart

tempdir=/tmp/kbmenu
nkloopfifo=$tempdir/nkloopfifo
mkdir -p $tempdir
mkfifo $nkloopfifo
currentRotation=$(cat /sys/class/graphics/fb0/rotate)
fbgeometry=$(fbset | grep geometry | xargs)
while :
do
  if [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ]; then
    switchoffselection=$($ksmroot/kobomenu.sh -infolines=1 "-infotext=""Switch_off_wifi?" "yes no")
    case $switchoffselection in
      yes )
        $ksmroot/scripts_intern/wifi/wifi_disable.sh;;
    esac
  fi
  $kbmenuonstartdir/start_nickel.sh
  if [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ]; then
    if [ "${handleWifiAfterNickel}" == "disable" ]; then
      ${ksmroot}/scripts_intern/wifi/wifi_disable.sh
    elif [ "${handleWifiAfterNickel}" == "ask_the_user" ]; then
      switchoffselection=$($ksmroot/kobomenu.sh -infolines=1 "-infotext=""Switch_off_wifi?" "yes no")
      case $switchoffselection in
        yes )
          ${ksmroot}/scripts_intern/wifi/wifi_disable.sh;;
      esac
    fi
  fi

  if [ -p "$nkloopfifo" ]; then
    $kbmenuonstartdir/start_koreader.sh
  else
#set frontlight for KSM
    [ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && [ $PRODUCT != pika ] && (
    $frontlightprg "$KSMfrontlightlevel"
    )
    [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ] &&  $ksmroot/kbmessage.sh "Info: Wifi is enabled!"
    exit
  fi
done

killall fmon
