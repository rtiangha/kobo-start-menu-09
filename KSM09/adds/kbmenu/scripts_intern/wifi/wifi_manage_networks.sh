#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
wpaconfigfile=/etc/wpa_supplicant/wpa_supplicant.conf

if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "ksmroot: $ksmroot" >> $debug_logfile
fi

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
  answer=$(wpa_supplicant -B -D nl80211,wext -i ${INTERFACE} -c $wpaconfigfile)
  if [ "$?" -ne "0" ]; then
    answer=$(wpa_supplicant -B  -i ${INTERFACE} -c $wpaconfigfile)
  fi
  [ "$KSMdebugmode" == "true" ] && echo "wpa_supplicant -B -i ${INTERFACE} -c $wpaconfigfile: $answer" >> $debug_logfile
fi
sleep 1

[ "$KSMdebugmode" == "true" ] && echo "passed point 1" >> $debug_logfile

setoptions() {
  moptions=""
  knownnetworks=$(wpa_cli -i${INTERFACE} list_networks)
  [ "$KSMdebugmode" == "true" ] && echo "knownnetworks: $knownnetworks" >> $debug_logfile
  nw_ssids=$(echo "$knownnetworks" | awk '/\[/ {print $2}')
  nw_ssids=$(echo $nw_ssids)
  [ "$KSMdebugmode" == "true" ] && echo "nw_ssids: $nw_ssids" >> $debug_logfile

#  networkid=$(echo "$knownnetworks" | awk '{if ($2 == "'$ssid'") { print $1 }}')
#  [ "$KSMdebugmode" == "true" ] && echo "networkid: $networkid" >> $debug_logfile
# for nw_ssid in "$nw_ssids"
  for nw_ssid in $nw_ssids
  do
    [ "$KSMdebugmode" == "true" ] && echo "looping: for nw_ssid in $nw_ssids; nw_ssid: $nw_ssid " >> $debug_logfile

    nw_id=$(echo "$knownnetworks" | awk -v the_ssid=$nw_ssid '{if($2==the_ssid) {print $1}}')
    [ "$KSMdebugmode" == "true" ] && echo "nw_id: $nw_id" >> $debug_logfile

    status=$(wpa_cli -i${INTERFACE} get_network "$nw_id" disabled)
    [ "$KSMdebugmode" == "true" ] && echo "status: $status" >> $debug_logfile
    if [ "$status" == "0" ]; then
      moptions="$moptions $nw_ssid:check.png"
    else
      moptions="$moptions $nw_ssid:delete.png"
    fi
  done
  moptions="$moptions save:execute.png return:arrowup.png return_home:arrowup.png"
  [ "$KSMdebugmode" == "true" ] && echo "moptions: $moptions" >> $debug_logfile
}

selection=""
while [ "$selection" != "EXIT" ]; do
  [ "$KSMdebugmode" == "true" ] && echo "entered selection loop" >> $debug_logfile
  setoptions
  selection=$($ksmroot/kobomenu.sh $moptions)
  case $selection in
    save)
      answer=$(wpa_cli -i${INTERFACE} save)
      [ "$KSMdebugmode" == "true" ] && echo "wpa_cli -i${INTERFACE} save: $answer" >> $debug_logfile
      ;;
    return)  selection="EXIT";;
    return_home)
      selection="EXIT"
      echo "return_home"
      ;;
    *)
      actionmoptions="-infolines=1 -infotext=$selection select:execute.png remove:execute.png return:arrowup.png"
      actionselection=$($ksmroot/kobomenu.sh $actionmoptions)
      case $actionselection in
        select)
          networkid=$(echo "$knownnetworks" | awk -v the_ssid=$selection '{if($2==the_ssid) {print $1}}')
          [ "$KSMdebugmode" == "true" ] && echo "networkid: $networkid" >> $debug_logfile
          answer=$(wpa_cli -i${INTERFACE} select_network $networkid)
          [ "$KSMdebugmode" == "true" ] && echo "select_network -i${INTERFACE} $networkid: $answer" >> $debug_logfile
          sleep 1
          ;;
        remove)
          networkid=$(echo "$knownnetworks" | awk -v the_ssid=$selection '{if($2==the_ssid) {print $1}}')
          [ "$KSMdebugmode" == "true" ] && echo "networkid: $nw_id" >> $debug_logfile
          answer=$(wpa_cli -i${INTERFACE} remove_network $networkid)
          [ "$KSMdebugmode" == "true" ] && echo "remove_network -i${INTERFACE} $networkid: $answer" >> $debug_logfile
          sleep 1
          ;;
      esac
      ;;
  esac
done
