#!/bin/sh
#20181211_22:00
#recognize newer models
#20180927_23:00
#new: nightmode
#20180717_21:41
#new: changed approach to rotation
#new: settings for nova
#new: changed: start server at start; enable usbnet; enable wifi
#20180311_22:37
#new: handleWifiAfterKOReader
#20180126_22:46
#new: isKSMsecondaryversion
#new: rmc menu
#new: H2O2 fb=0; mrotation=270
#new: KoboTS_h2o2
#new: start server at start; enable usbnet; enable wifi
#new: start_blank
#new: handle_update (new version)
#new: start_plato
#new: changed approach to rotation


# H2O2 (snow) would have 2, but the touch driver only supports 0 orientation
case $PRODUCT in
  dragon|dahlia)
    export ksmrotate=2
    ;;
  *)
    export ksmrotate=0
    ;;
esac


isKSMsecondaryversion=${isKSMsecondaryversion:-"false"}
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
ksmFontDir=$ksmroot/fonts

export ksmroot
export ksmuser
export koreaderbasedir=/mnt/onboard/.adds
export platobasedir=/mnt/onboard/.adds/plato
export ksmNightmode=false

### function configureKSM - begin
configureKSM() {
  ksmAutoselectafter=20
  ksmAutoselectoption=start_nickel
  KSMdebugmode=false
  duringPWcheckActivate=
  dontTamperwithFrontlight=true
  nickelpreload=
  avoidPickel=false
  frontlightOnLevel=4
  insertCRportrait=false
  insertCRlandscape=false
  combineCoolreaderAdditions=false
  insertNickelKoreaderSwitch=true
  insertKoreaderNickelSwitch=true
  selectKoreaderVersion=true
  combineKoreaderAdditions=true
  deleteSDRsOnboard=false
  enablerotation=false
  preventfreeze=true
  useDropbear=true
  useMultiplefonts=true
  kobomenuShowClock=false
  poweroffRandomdir=
  poweroffRotation=90
  powerOffDelay=0.8
  provideSleepInMainMenu=false
  suppressEntries=
  mrotation=90
  allowRmcViaWifi=true
  handleWifiAfterKOReader=ask_the_user
  ksmColorsNight="-bg black -fg white -btn green"
  ksmColorsDay="-fg black -bg white"
  vlasovsoftbasedir=
  if [ -e /mnt/onboard/.adds/vlasovsoft/launcher ]; then
    vlasovsoftbasedir=/mnt/onboard/.adds/vlasovsoft
  elif [ -e /mnt/onboard/.kobo/vlasovsoft/launcher ]; then
    vlasovsoftbasedir=/mnt/onboard/.kobo/vlasovsoft
  fi
  export vlasovsoftbasedir


  case $PRODUCT in
    phoenix )
      ksmGeometryValuesN=758x1012+0+0
      ksmGeometryValuesS=758x1012+0+11
      ksmGeometryValuesE=1012x758+0+0
      ksmGeometryValuesW=1012x758+11+0
      ;;
    dahlia )
      ksmGeometryValuesN=1080x1429+0+11
      ksmGeometryValuesS=1080x1429+0+0
      ksmGeometryValuesE=1429x1080+11+0
      ksmGeometryValuesW=1429x1080+0+0
      ;;
    * )
      ksmGeometryValuesN=
      ksmGeometryValuesS=
      ksmGeometryValuesE=
      ksmGeometryValuesW=
      ;;
  esac

  case $PRODUCT in
    kraken)
      ksmImageWidthPortrait=724
      ksmImageWidthLandscape=800
      ;;
    phoenix)
      ksmImageWidthPortrait=714
      ksmImageWidthLandscape=790
      ;;
    dragon)
      ksmImageWidthPortrait=1040
      ksmImageWidthLandscape=1384
      ;;
    dahlia)
      ksmImageWidthPortrait=1040
      ksmImageWidthLandscape=1384
      ;;
    *)
      ksmImageWidthPortrait=566
      ksmImageWidthLandscape=750
      ;;
  esac

  case $PRODUCT in
    kraken)
      kobomenuFontsize=40
      kobomenuMenuBarFontsize=35
      ;;
    phoenix)
      kobomenuFontsize=40
      kobomenuMenuBarFontsize=35
      ;;
    star)
      kobomenuFontsize=40
      kobomenuMenuBarFontsize=35
      ;;
    dragon)
      kobomenuFontsize=50
      kobomenuMenuBarFontsize=40
      ;;
    daylight)
      kobomenuFontsize=64
      kobomenuMenuBarFontsize=50
      ;;
    dahlia)
      kobomenuFontsize=55
      kobomenuMenuBarFontsize=45
      ;;
    alyssum)
      kobomenuFontsize=60
      kobomenuMenuBarFontsize=50
      ;;
    snow)
      kobomenuFontsize=60
      kobomenuMenuBarFontsize=50
      ;;
    nova)
      kobomenuFontsize=60
      kobomenuMenuBarFontsize=50
      ;;
    *)
      kobomenuFontsize=35
      kobomenuMenuBarFontsize=25
      ;;
  esac

  configfile=$ksmroot/ksm_ini
  if [ -e $configfile ]; then
    while read p; do
      p="${p#"${p%%[![:space:]]*}"}"
      case "$p" in
        [*|export*|'#'* ) ;;
        *=|*=* )
          eval "$p" > /dev/null 2>&1
          ;;
      esac
    done <$configfile
  elif [ -f "${configfile}_template" ]; then
    cp "${configfile}_template" "$configfile"
  fi

  if [ "$insertCRportrait" != "true" ] && [ "$insertCRlandscape" != "true" ]; then
    combineCoolreaderAdditions=false
  fi

  export kobomenuFontsize
  export kobomenuMenuBarFontsize
  export ksmImageWidthPortrait
  export ksmImageWidthLandscape
  export ksmGeometryValuesN
  export ksmGeometryValuesS
  export ksmGeometryValuesE
  export ksmGeometryValuesW
  export KSMdebugmode
  export dontTamperwithFrontlight
  export nickelpreload
  export deleteSDRsOnboard
  export avoidPickel
  export kobomenuShowClock
  export poweroffRandomdir
  export poweroffRotation
  export powerOffDelay
  export useDropbear
  export provideSleepInMainMenu
  export allowRmcViaWifi
  export handleWifiAfterKOReader  
  export ksmColorsNight
  export ksmColorsDay

  if [ "$PRODUCT" == "snow" ]; then
    mrotation=270
    enablerotation=false
  fi
  export mrotation

  if [ "$useMultiplefonts" == "true" ]; then
    export QWS_NO_SHARE_FONTS=1
  else
    export QWS_NO_SHARE_FONTS=0
  fi
### select font dir: begin
  fonttestdirs="$ksmFontDir \
  $ksmuser/fonts \
  $ksmroot/fonts"

  containsfont() {
    local result
    result="false"
    [ -d "$1" ] || exit
    for f in $(find "$1" -type f -maxdepth 1 -iname "*.ttf" -o -iname "*.otf" -o -iname "*.ttc")
    do
      result="true"
      break
    done
    echo $result
  }

  for dir in $fonttestdirs
  do
    if [ "$(containsfont "$dir")" == "true" ]; then
      ksmFontDir="$dir"
      break
    fi
  done

  export ksmFontDir
### select font dir: end
  [ "x${suppressEntries}" != "x" ] && showFull="false" || showFull="true"
}

### function configureKSM - end

frontlightprg=$ksmroot/tools/frontlight
export KSMfrontlightlevel=0

isFirstRun="TRUE"
startwithlighton=false
# switch off leds begin
echo "ch 4" > /sys/devices/platform/pmic_light.1/lit
echo "cur 0" > /sys/devices/platform/pmic_light.1/lit
echo "dc 0" > /sys/devices/platform/pmic_light.1/lit
#switch off leds end

modelnr=$($ksmroot/onstart/getmodelnr.sh)
case $modelnr in
  310 ) PRODUCT_ID=0x4163;; # Touch A/B
  320 ) PRODUCT_ID=0x4163;; # Touch C
  330 ) PRODUCT_ID=0x4173;; # Glo
  340 ) PRODUCT_ID=0x4183;; # Mini
  350 ) PRODUCT_ID=0x4193;; # Aura HD
  360 ) PRODUCT_ID=0x4203;; # Aura
  370 ) PRODUCT_ID=0x4213;; # Aura H2O
  371 ) PRODUCT_ID=0x4223;; # Glo HD
  372 ) PRODUCT_ID=0x4224;; # Touch 2.0
  373 ) PRODUCT_ID=0x4225;; # Aura ONE
  374 ) PRODUCT_ID=0x4227;; # Aura H2O Edition 2 v1
  375 ) PRODUCT_ID=0x4226;; # Aura Edition 2 v1
  376 ) PRODUCT_ID=0x4228;; # Clara HD
  377 ) PRODUCT_ID=0x4229;; # Forma
  378 ) PRODUCT_ID=0x4227;; #? Aura H2O Edition 2 v2
  379 ) PRODUCT_ID=0x4226;; #? Aura Edition 2 v2
  380 ) PRODUCT_ID=0x4229;; # Forma 32G
## is the next correct?
  381 ) PRODUCT_ID=0x4225;; # Aura ONE Limited Edition
  384 ) PRODUCT_ID=0x4232;; # Libra H2O
  * ) PRODUCT_ID=0x9999;;
esac
export PRODUCT_ID
export fbrotatevalue=0


configureKSM


if [ "$isKSMsecondaryversion" != "true" ]; then
  if [ ! -e "${ksmuser}/dont_enable_usbnet_at_boot" ]; then
    ${ksmroot}/scripts_intern/usb/usbnet_toggle.sh
  fi
  if [ ! -e "${ksmuser}/dont_enable_wifi_at_boot" ]; then
    ${ksmroot}/scripts_intern/wifi/wifi_enable_dhcp.sh
#sleep 5
  fi
  if [ ! -e "${ksmuser}/dont_enable_rmc_at_boot" ]; then
    ${ksmroot}/scripts/web_servers/rmc_start.sh
    ${ksmroot}/scripts_intern/div/killautormcatsomepoint.sh &>/dev/null &
  fi
fi


if [ -f "${ksmuser}/start_blank" ]; then
  rm "${ksmuser}/start_blank"
  exit
fi



if [ "$preventfreeze" == "true" ]; then
  $ksmroot/onstart/preventfreeze.sh &
fi

if [ "$startwithlighton" == "true" ]; then
  $frontlightprg "$frontlightOnLevel"
  export KSMfrontlightlevel=$frontlightOnLevel
fi

### password check - begin
pwfile="$ksmroot/kbbouncer/bouncerpw.txt"
if [ -e $pwfile ] && [ "$($ksmroot/onstart/checkbouncerinstall.sh)" == "ok" ]; then
  case $duringPWcheckActivate in
    usb )
      [ "$KSMdebugmode" == "true" ] && echo "password check: call $ksmroot/scripts_intern/usb/usb_enable.sh" >> $debug_logfile
      $ksmroot/scripts_intern/usb/usb_enable.sh
      ;;
    usbnet )
      [ "$KSMdebugmode" == "true" ] && echo "password check: call $ksmroot/scripts_intern/usb/usbnet_toggle.sh" >> $debug_logfile
      $ksmroot/scripts_intern/usb/usbnet_toggle.sh
      ;;
  esac
  export KBBouncerMode=
  bouncer=$ksmroot/kbbouncer/kbbouncer.sh
  pw=$(cat $pwfile)
  answer=""
  pwcount=0
  while [ "$answer" != "passed" ] && [ $pwcount -lt 3 ]; do
    answer=$($bouncer "$pw")
    let pwcount++
  done
  if [ "$answer" == "failed" ]; then
    $ksmroot/onstart/poweroff.sh
  fi
  case $duringPWcheckActivate in
    usb )
      $ksmroot/scripts_intern/usb/usb_disable.sh
      ;;
    usbnet )
      $ksmroot/scripts_intern/usb/usbnet_toggle.sh
      ;;
  esac
fi
### password check - begin


setKSMupdateoptions() {
  mksmupdateoptions="info:help.png"
  for f in $(find $ksmuser -name "KSM*.zip")
  do
    mksmupdateoptions="$mksmupdateoptions install_KSM_update:execute.png"
    mksmupdateoptions="$mksmupdateoptions delete_KSM_update:execute.png"
    break
  done
  mksmupdateoptions="$mksmupdateoptions show_KSM_update_history:help.png"
  mksmupdateoptions="$mksmupdateoptions return"
}

addMenuEntryStringIfWished() {
  local menuEntryString=$1
  local menuEntry="+${menuEntryString%:*}+"
  if  [ ${showFull} == "true" ] || [ "x${suppressEntries#*$menuEntry}" == "x${suppressEntries}" ]; then
    moptions="${moptions} ${menuEntryString}"
  fi
}


setoptions() {
  moptions=""
  if [ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && [ $PRODUCT != pika ]; then
    addMenuEntryStringIfWished "front_light_on:execute.png"
    addMenuEntryStringIfWished "front_light_off:execute.png"
  fi

  addMenuEntryStringIfWished "info:help.png"
  addMenuEntryStringIfWished "toggle_nightmode:toggle.png"

  if [ "$enablerotation" == "true" ]; then
    addMenuEntryStringIfWished "toggle_rotation:toggle.png"
  fi

#####
  for f in $(find $ksmuser -name "KSM*.zip")
  do
    moptions="$moptions handle_KSM_update:gear.png"
    break
  done
#####


#####
  if [ -e /mnt/onboard/.kobo/Kobo.tgz ] || [ -e /mnt/onboard/.kobo/KoboRoot.tgz ]; then
    moptions="$moptions handle_update:gear.png "
  fi
#####
  if [ -d /mnt/onboard/.kobo ]; then
    addMenuEntryStringIfWished "start_nickel:book.png"
  fi

  if [ -e /mnt/onboard/.adds/koreader/reader.lua ]; then
    addMenuEntryStringIfWished "start_koreader:book.png"
    if  [ "$combineKoreaderAdditions" == "true" ]; then
      KoreaderAdditionsmoptions=
      [ "$insertNickelKoreaderSwitch" == "true" ] && KoreaderAdditionsmoptions="$mKoreaderAdditionsmoptions start_nickel_koreader_switch:book.png"
      [ "$insertKoreaderNickelSwitch" == "true" ] && KoreaderAdditionsmoptions="$KoreaderAdditionsmoptions start_koreader_nickel_switch:book.png"
      [ "$selectKoreaderVersion" == "true" ] && KoreaderAdditionsmoptions="$KoreaderAdditionsmoptions select_koreader_version:menu.png"
      [ -d "$ksmroot/koreaderfindsh" ] && KoreaderAdditionsmoptions="$KoreaderAdditionsmoptions find_and_open:menu.png"
      KoreaderAdditionsmoptions="$KoreaderAdditionsmoptions return:arrowup.png"
      addMenuEntryStringIfWished "koreader_additions:menu.png"
    else
      [ "$insertNickelKoreaderSwitch" == "true" ] && addMenuEntryStringIfWished "start_nickel_koreader_switch:book.png"
      [ "$insertKoreaderNickelSwitch" == "true" ] && addMenuEntryStringIfWished "start_koreader_nickel_switch:book.png"
      [ "$selectKoreaderVersion" == "true" ] && addMenuEntryStringIfWished "select_koreader_version:menu.png"
      [ -d "$ksmroot/koreaderfindsh" ] && addMenuEntryStringIfWished "find_and_open:menu.png"
    fi
  fi

 
  if [ -e /mnt/onboard/.adds/plato/plato ]; then
    addMenuEntryStringIfWished "start_plato:book.png"
  fi
 
  if [ -e /mnt/onboard/.kobo/KoboLauncher/launcher ]; then
    addMenuEntryStringIfWished "start_kobolauncher:rocket.png"
  fi


  if [ "$vlasovsoftbasedir" != "" ]; then
    addMenuEntryStringIfWished "start_vlasovsoftlauncher:rocket.png"
    if  [ "$combineCoolreaderAdditions" == "true" ]; then
      CoolreaderAdditionsmoptions=
      [ "$insertCRportrait" == "true" ] && CoolreaderAdditionsmoptions="$CoolreaderAdditionsmoptions start_coolreader:book.png"
      [ "$insertCRlandscape" == "true" ] && CoolreaderAdditionsmoptions="$CoolreaderAdditionsmoptions start_coolreader_ls:book.png"
      CoolreaderAdditionsmoptions="$CoolreaderAdditionsmoptions return:arrowup.png"
      addMenuEntryStringIfWished "coolreader:menu.png"
    else
      [ "$insertCRportrait" == "true" ] && addMenuEntryStringIfWished "start_coolreader:book.png"
      [ "$insertCRlandscape" == "true" ] && addMenuEntryStringIfWished "start_coolreader_ls:book.png"
    fi
  fi

  addMenuEntryStringIfWished "usb:usb.png"
  addMenuEntryStringIfWished "wifi:wifi.png"
  addMenuEntryStringIfWished "configure:gear.png"
  if [ -e "${ksmroot}/rmc" ]; then
    addMenuEntryStringIfWished "rmc_start:toggle.png"
    addMenuEntryStringIfWished "rmc_stop:toggle.png"
  fi
  addMenuEntryStringIfWished "tools:menu.png"
  addMenuEntryStringIfWished "scripts:menu.png"

  [ -e "$ksmuser/scripts" ] && addMenuEntryStringIfWished "user_scripts:menu.png"
  [ "$provideSleepInMainMenu" == "true" ] &&addMenuEntryStringIfWished "sleep:moon.png"


  [ "x${suppressEntries}" != "x" ] && moptions="$moptions toggle_btw_full_and_short_menu:toggle.png"
  addMenuEntryStringIfWished "reboot:restart.png"
  addMenuEntryStringIfWished "power_off:poweroff.png"

  if [ "$isKSMsecondaryversion" == "true" ]; then
    moptions="$moptions exit_to_calling_KSM:arrowup.png"
  fi
}

(
if [ "$avoidPickel" != "true" ]; then
  /usr/local/Kobo/pickel disable.rtc.alarm
fi
echo 1 > /sys/devices/platform/mxc_dvfs_core.0/enable
/sbin/hwclock -s -u
) &


[ "$KSMdebugmode" == "true" ] && sync
#mrotation="90"
#export mrotation
udevadm trigger

#---- do the menu loop
selection=""
while [ "$selection" != "EXIT" ]; do
  setoptions
  if [ "$isFirstRun" == "TRUE" ]; then
    if [ "$ksmAutoselectoption" != "" ] && [ "$ksmAutoselectoption" != "reboot" ] && [ "$ksmAutoselectoption" != "power_off" ]; then
      moptions="-autoselectafter=$ksmAutoselectafter -autoselectoption=$ksmAutoselectoption $moptions"
    fi
    usbnetInfo="$(${ksmroot}/scripts_intern/div/get_usbnet_ip.sh)"
    if [ ! -e "${ksmuser}/dont_enable_wifi_at_boot" ]; then
      wifiInfo="$(${ksmroot}/scripts_intern/div/get_wifi_ip.sh)"
    else
      wifiInfo="wifi_ip:_not_enabled"
    fi
    if [ ! -e "${ksmuser}/dont_enable_rmc_at_boot" ]; then
      rmcInfo="$(${ksmroot}/scripts_intern/div/get_rmc_state.sh)"
    else
      rmcInfo="rmc_server_is_not_running"
    fi
    infotext="${usbnetInfo}<br>${wifiInfo}<br>${rmcInfo}"
    moptions="-infolines=3 -infotext=${infotext} ${moptions}"
    isFirstRun="FALSE"
  fi
  selection=$($ksmroot/kobomenu.sh $moptions)
  case $selection in
    exit_to_calling_KSM )
      exit;
      ;;
    info )
      $ksmroot/kbmessage.sh "-f $ksmuser/txt/start_info.html"
      ;;
    handle_update )
      $ksmroot/helpers/handle_update.msh
      ;;
##
    handle_KSM_update )
      ksmupdateselection=""
      binfo="capacity: `cat /sys/devices/platform/pmic_battery.1/power_supply/mc13892_bat/capacity`"
      while [ "$ksmupdateselection" != "EXIT" ]; do
        setKSMupdateoptions
        binfo=${binfo// /_}
        ksmupdateselection=$($ksmroot/kobomenu.sh -infolines=1 "-infotext=$binfo" $mksmupdateoptions)
        case $ksmupdateselection in
          info )
            $ksmroot/kbmessage.sh "-f $ksmroot/scripts_intern/ksmupdate/info.txt"
            ;;
          install_KSM_update )
            binfo=$($ksmroot/scripts_intern/ksmupdate/installupdates.sh)
            ;;
          delete_KSM_update )
            rm -f "$ksmuser"/KSM*.zip
            ;;
          show_KSM_update_history )
            $ksmroot/kbmessage.sh "-f $ksmroot/updatehistory.txt"
            ;;
          return )
            ksmupdateselection="EXIT"
            ;;
        esac
      done
      ;;
##
    toggle_btw_full_and_short_menu )
      [ "x${showFull}" == "xtrue" ] && showFull="false" || showFull="true"
      ;;
    toggle_rotation )
      if [ "$mrotation" == "0" ]; then
        mrotation="90"
      elif [ "$mrotation" == "90" ]; then
        mrotation="180"
      elif [ "$mrotation" == "180" ]; then
        mrotation="270"
      elif [ "$mrotation" == "270" ]; then
        mrotation="0"
      fi
      export mrotation
      ;;
    toggle_nightmode )
      if [ "${ksmNightmode}" == "true" ]; then
        export ksmNightmode="false"
      else
        export ksmNightmode="true"
      fi
      ;;
    start_nickel )
      $ksmroot/onstart/start_nickel.sh
      ;;
    power_off )
      $ksmroot/onstart/poweroff.sh
      ;;
    sleep )
      $ksmroot/onstart/suspend.sh
      ;;
    reboot )
      reboot
      ;;
    usb )
      $ksmroot/onstart/scriptmenuusb.sh $ksmroot/scripts_intern/usb
      ;;
    wifi )
      $ksmroot/onstart/scriptmenuwifi.sh $ksmroot/scripts_intern/wifi
      ;;
    configure )
      confresp=$($ksmroot/kbconfsel.sh $ksmroot/ksm_ini -optionsfile=$ksmuser/confoptions/ksm_ini_options.txt)
      if  [ "$confresp" == "saved" ]; then
        configureKSM
      fi
      ;;
    tools )
      $ksmroot/helpers/list_shscripts.msh $ksmroot/scripts_intern/tools
      ;;
    scripts )
      $ksmroot/helpers/list_shscripts.msh $ksmroot/scripts
      ;;
    user_scripts )
      $ksmroot/helpers/list_shscripts.msh $ksmuser/scripts
      ;;
    start_koreader )
      $ksmroot/onstart/start_koreader.sh
      ;;
    start_nickel_koreader_switch )
      $ksmroot/onstart/nickelkoreaderloop.sh
      ;;
    start_koreader_nickel_switch )
      $ksmroot/onstart/koreadernickelloop.sh
      ;;
    koreader_additions )
      koreaderadditionsselection=$($ksmroot/kobomenu.sh $KoreaderAdditionsmoptions)
      case $koreaderadditionsselection in
        start_nickel_koreader_switch )
          $ksmroot/onstart/nickelkoreaderloop.sh
          ;;
        start_koreader_nickel_switch )
          $ksmroot/onstart/koreadernickelloop.sh
          ;;
        find_and_open )
          $ksmroot/helpers/list_shscripts.msh "$ksmroot/koreaderfindsh"
          ;;
        select_koreader_version )
          $ksmroot/helpers/list_koreaderdirs.msh "$koreaderbasedir"
          ;;
      esac
      ;;
    start_plato )
      $ksmroot/onstart/start_plato.sh
      ;;
    start_kobolauncher )
      $ksmroot/onstart/start_KoboLauncherA.sh
      ;;
    start_vlasovsoftlauncher )
      $ksmroot/onstart/start_vlasovlauncher.sh
      ;;
    start_coolreader )
      $ksmroot/onstart/cr3.sh
      ;;
    start_coolreader_ls )
      $ksmroot/onstart/cr3_180.sh
      ;;
    coolreader )
      coolreaderselection=$($ksmroot/kobomenu.sh $CoolreaderAdditionsmoptions)
      case $coolreaderselection in
        start_coolreader )
          $ksmroot/onstart/cr3.sh
          ;;
        start_coolreader_ls )
          $ksmroot/onstart/cr3_180.sh
          ;;
      esac
      ;;

    front_light_on )
      $frontlightprg "$frontlightOnLevel"
      export KSMfrontlightlevel=$frontlightOnLevel
      ;;
    front_light_off )
      $frontlightprg "0"
      export KSMfrontlightlevel=0
      ;;
    start_nickel_koreader_switch )
      $ksmroot/onstart/nickelkoreaderloop.sh
      ;;
    start_koreader_nickel_switch )
      $ksmroot/onstart/koreadernickelloop.sh
      ;;
    find_and_open )
      $ksmroot/helpers/list_shscripts.msh "$ksmroot/koreaderfindsh"
      ;;
    select_koreader_version )
      $ksmroot/helpers/list_koreaderdirs.msh "$koreaderbasedir"
      ;;
    rmc_start )
      $ksmroot/scripts/web_servers/rmc_start.sh
      ;;
    rmc_stop )
      $ksmroot/scripts/web_servers/rmc_stop.sh
      ;;
  esac
done

