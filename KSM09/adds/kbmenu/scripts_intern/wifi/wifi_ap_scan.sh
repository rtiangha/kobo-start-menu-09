#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
wpaconfigfile=/etc/wpa_supplicant/wpa_supplicant.conf

infolines=2


if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "ksmroot: $ksmroot" >> $debug_logfile
fi



bouncer=$ksmroot/kbbouncer/kbbouncer.sh

if [ ! -e "$wpaconfigfile" ]; then
  echo "ctrl_interface=/var/run/wpa_supplicant" > "$wpaconfigfile"
  echo "update_config=1" >> "$wpaconfigfile"
fi

lsmod | grep -q sdio_wifi_pwr || insmod /drivers/$PLATFORM/wifi/sdio_wifi_pwr.ko
lsmod | grep -q ${WIFI_MODULE} || insmod /drivers/$PLATFORM/wifi/${WIFI_MODULE}.ko
sleep 2

answer=$(ifconfig ${INTERFACE})
[ "$KSMdebugmode" == "true" ] && echo "ifconfig: $answer" >> $debug_logfile
case $answer in
  *error*)
    ifconfig ${INTERFACE} up
    [ ${WIFI_MODULE} = 8189fs ] || [ ${WIFI_MODULE} = 8189es ] || wlarm_le -i ${INTERFACE} up
    ;;
esac


if [ ! -e "/var/run/wpa_supplicant/${INTERFACE}" ]; then
  answer=$(wpa_supplicant -D nl80211,wext -B -i ${INTERFACE} -c $wpaconfigfile)
  if [ "$?" -ne "0" ]; then
    answer=$(wpa_supplicant -B  -i ${INTERFACE} -c $wpaconfigfile)
  fi
  [ "$KSMdebugmode" == "true" ] && echo "wpa_supplicant -B -i ${INTERFACE} -c $wpaconfigfile: $answer" >> $debug_logfile
  answer=$(/sbin/udhcpc -S -i ${INTERFACE} -s /etc/udhcpc.d/default.script -t15 -T10 -A3 -b -q >/dev/null 2>&1 & )
  [ "$KSMdebugmode" == "true" ] && echo "/sbin/udhcpc -S -i ${INTERFACE} -s /etc/udhcpc.d/default.script -t15 -T10 -A3 -b -q: $answer" >> $debug_logfile
fi
sleep 1
knownnetworks=$(wpa_cli -i${INTERFACE} list_networks)
[ "$KSMdebugmode" == "true" ] && echo "knownnetworks: $knownnetworks" >> $debug_logfile


scan() {
  wpa_cli -i${INTERFACE}  scan
  scanresults=$(wpa_cli -i${INTERFACE} scan_results)
  [ "$KSMdebugmode" == "true" ] && echo "scanresults: $scanresults" >> $debug_logfile
  ap_ssids=$(echo "$scanresults" | awk '/\[/ {print $5}')
  [ "$KSMdebugmode" == "true" ] && echo "ap_ssids: $ap_ssids" >> $debug_logfile
}

setoptions() {
  status=$(wpa_cli -i${INTERFACE} status)
  infotext=$(echo -e "$status" | awk '$1 ~ /^ssid=/')
  infotext="$infotext<p>$(echo -e "$status" | awk '$1 ~ /^wpa_state=/')"
  infotext=$(echo $infotext)
  infotext=${infotext// /_}
  moptions="-infolines=$infolines"
  moptions="$moptions -infotext=$infotext"
  moptions="$moptions refresh:execute.png"

  for ssid in $ap_ssids
  do
    networkid=$(echo "$knownnetworks" | awk '{if ($2 == "'$ssid'") { print $1 }}')
    [ "$KSMdebugmode" == "true" ] && echo "networkid: $networkid" >> $debug_logfile

    if [ "$networkid" == "" ]; then
      moptions="$moptions $ssid"
    else
      answer=$(wpa_cli -i${INTERFACE} get_network "$networkid" disabled)
      [ "$KSMdebugmode" == "true" ] && echo "wpa_cli -i${INTERFACE} getnetwork $networkid disabled: $answer" >> $debug_logfile
      if [ "$answer" == "0" ]; then
        moptions="$moptions $ssid:check.png"
      else
        moptions="$moptions $ssid:delete.png"
      fi
    fi
  done
  moptions="$moptions return:arrowup.png return_home:arrowup.png"
  [ "$KSMdebugmode" == "true" ] && echo "moptions: $moptions" >> $debug_logfile

}

scan
selection=""
while [ "$selection" != "EXIT" ]; do
  setoptions
  selection=$($ksmroot/kobomenu.sh $moptions)
  case $selection in
    refresh) scan;;
    return)  selection="EXIT";;
    return_home)
      selection="EXIT"
      echo "return_home"
      ;;
    *)
      nwid=$(wpa_cli -i${INTERFACE} list_networks | awk '{if ($2 == "'$selection'") { print $1 }}')
      [ "$KSMdebugmode" == "true" ] && echo "nwid: $nwid" >> $debug_logfile
      if [ "$nwid" == "" ]; then
        networkid=$(wpa_cli -i${INTERFACE} add_network)
        [ "$KSMdebugmode" == "true" ] && echo "networkid: $networkid" >> $debug_logfile
        answer=$(wpa_cli -i${INTERFACE} set_network $networkid ssid \""$selection"\")
        [ "$KSMdebugmode" == "true" ] && echo "set_network ssid: $answer" >> $debug_logfile

        key_mgmt=$(echo "$scanresults" | awk '{if ($5 == "'$selection'") { print $4 }}')
        [ "$KSMdebugmode" == "true" ] && echo "key_mgmt: $key_mgmt" >> $debug_logfile


        case "$key_mgmt" in
          *PSK*)
            export KBBouncerMode=setPW
            pw1=$($bouncer)
            [ "$KSMdebugmode" == "true" ] && echo "pw1: $pw1" >> $debug_logfile
            pw1=$(wpa_passphrase "$selection" "$pw1" | grep ^\\\spsk | sed -e s/^\\\spsk=//)
            [ "$KSMdebugmode" == "true" ] && echo "pw1 encoded: $pw1" >> $debug_logfile
            answer=$(wpa_cli -i${INTERFACE} set_network $networkid psk $pw1)
            [ "$KSMdebugmode" == "true" ] && echo "set_network psk $pw1: $answer" >> $debug_logfile
            ;;
        esac

 #       answer=$(wpa_cli -i${INTERFACE} enable_network $networkid)
 #       [ "$KSMdebugmode" == "true" ] && echo "enable_network $networkid: $answer" >> $debug_logfile
       answer=$(wpa_cli select_network $networkid)
        [ "$KSMdebugmode" == "true" ] && echo "select_network $networkid: $answer" >> $debug_logfile



      else
        answer=$(wpa_cli -i${INTERFACE} select_network $nwid)
        [ "$KSMdebugmode" == "true" ] && echo "wpa_cli -i${INTERFACE} select_network $nwid: $answer" >> $debug_logfile

      fi
      sleep 1
        answer=$(wpa_cli save)
        [ "$KSMdebugmode" == "true" ] && echo "wpa_cli save: $answer" >> $debug_logfile

#    answer=$(dhcpcd ${INTERFACE})
#   [ "$KSMdebugmode" == "true" ] && echo "dhcpcd ${INTERFACE}: $answer" >> $debug_logfile
      answer=$(/sbin/udhcpc -S -i ${INTERFACE} -s /etc/udhcpc.d/default.script -t15 -T10 -A3 -b -q >/dev/null 2>&1 & )
      [ "$KSMdebugmode" == "true" ] && echo "/sbin/udhcpc -S -i ${INTERFACE} -s /etc/udhcpc.d/default.script -t15 -T10 -A3 -b -q: $answer" >> $debug_logfile
      ;;
  esac
done

