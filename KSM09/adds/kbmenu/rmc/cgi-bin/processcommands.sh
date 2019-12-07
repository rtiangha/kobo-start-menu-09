#!/bin/busybox sh

killall killautormcatsomepoint.sh 2>/dev/null

logthis=false

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
allowRmcViaWifi=${allowRmcViaWifi:-"false"}
eventdatadir=${ksmroot}/pressdata
thisparent=$(dirname $(dirname $(readlink -f $0)))
logfile=${thisparent}/logfile.txt

if [ "${allowRmcViaWifi}" != "true" ]; then
  case ${REMOTE_ADDR} in
    192.168.2.* ) ;;
    * )
      echo "Content-type: text/html"
      echo ""
      echo ""
      echo "<html>"
      echo "<body>"
      echo "<p>Use is restricted to usbnet</p>"
      echo "</body>"
      echo "</html>"
      exit 0
      ;;
  esac
fi


urldecode() {
  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
}

[ "$REQUEST_METHOD" == "POST" ] && read QUERY_STRING
[ "$logthis" == "true" ] || echo "$(date +%Y%m%d_%H%M%S)" >> ${logfile}
[ "$logthis" == "true" ] || echo "QUERY_STRING: $QUERY_STRING" >> ${logfile}
comtype=$(echo "${QUERY_STRING}" | awk 'BEGIN{RS="\&"; FS="="} { if ($1=="com_type") {print $2}}')
comvalue=$(echo "${QUERY_STRING}" | awk 'BEGIN{RS="\&"; FS="="} { if ($1=="com_value") {print $2}}')

[ "$logthis" == "true" ] || echo "comtype: $comtype" >> ${logfile}
[ "$logthis" == "true" ] || echo "comvalue: $comvalue" >> ${logfile}


getparams=$(echo "${HTTP_REFERER}" | awk 'BEGIN{RS="\?";} { if (NR==2) {print $0}}')
pparams=$(echo "${getparams}" | awk 'BEGIN{RS="\&"; FS="="} { if ($1=="pparams") {print $2}}')
pquerystring=$(echo "${getparams}" | awk 'BEGIN{RS="\&"; FS="="} { if ($1=="pquerystring") {print $2}}')
pexecuted=$(echo "${getparams}" | awk 'BEGIN{RS="\&"; FS="="} { if ($1=="pexecuted") {print $2}}')

pexecuted=${pexecuted:-"true"}
pquerystring=${pquerystring:-"false"}
pparams=${pparams:-"false"}


message="messages:"
case ${comtype} in
  touch)
    [ "$logthis" == "true" ] || echo "arrived in comptype: ${comtype}" >> ${logfile}
    if [ "x${comvalue}" != "x" ]; then
      if [ -e ${eventdatadir}/${comvalue} ]; then
        [ "$logthis" == "true" ] || echo "found ${eventdatadir}/${comvalue}" >> ${logfile}
        cat ${eventdatadir}/${comvalue} > /dev/input/event1
        message="${message}<br>cat ${eventdatadir}/${comvalue} > /dev/input/event1"
      else
        [ "$logthis" == "true" ] || echo "cannot find${eventdatadir}/${comvalue}" >> ${logfile}
        message="${message}<br>cannot find ${eventdatadir}/${comvalue}"
      fi
    else
      message="${message}<br>missing name of event file"
    fi
    ;;
  shell)
    [ "$logthis" == "true" ] || echo "arrived in comptype: ${comtype}" >> ${logfile}
    if [ "x${comvalue}" != "x" ]; then
      comvalue=$(urldecode "${comvalue}")
      [ "$logthis" == "true" ] || echo "comvalue: ${comvalue}" >> ${logfile}
      message2=${comvalue}
      message=$(eval ${comvalue})
    fi
    ;;
esac

echo "Content-type: text/html"
echo ""
echo ""
echo "<html>"
echo "<body>"
echo "<p>"
[ "${pquerystring}" == "true" ] && echo "### query string:$QUERY_STRING<br />"
[ "${pparams}" == "true" ] && echo "### getparams:${getparams}<br />"
[ "${pexecuted}" == "true" ] && echo "### executed:${message2}<br />"
echo "<pre>${message}</pre>"
echo "</p>"
echo "</body>"
echo "</html>"

[ "$logthis" == "true" ] || echo "arrived at end of script" >> ${logfile}

exit 0
