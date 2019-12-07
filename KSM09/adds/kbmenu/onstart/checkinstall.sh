#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

filename=$ksmuser/runsettings.txt

if [ ! -e $filename ]; then 
cat <<EOF >> $filename
# You can define here whether after booting the menu starts always, never, once, alternating
# use one of these options: 
# runmenu=always
# runmenu=once
# runmenu=never
# runmenu=alternateNickel
# runmenu=alternateMenu

runmenu=alternateMenu
EOF
  echo "failed_no_settings_file"
  exit
fi

if [ $(grep -c '^runmenu=always' "$filename") -eq 0 ]; then
  if [ $(grep -c '^runmenu=once' "$filename") -gt 0 ]; then
    sed -i "s/^runmenu=once/runmenu=never/" $filename
    sync
  elif [ $(grep -c '^runmenu=alternateMenu' "$filename") -gt 0 ]; then
    sed -i "s/^runmenu=alternateMenu/runmenu=alternateNickel/" $filename
    sync
  elif [ $(grep -c '^runmenu=alternateNickel' "$filename") -gt 0 ]; then
    sed -i "s/^runmenu=alternateNickel/runmenu=alternateMenu/" $filename
    sync
    echo "failed_run_nickel"
    exit
  else
    echo "failed_never_or_unkown_option"
    exit
  fi
fi

if [ ! -e $ksmroot/kobomenu ] ||\
  [ ! -e $ksmroot/kobomenu.sh ] ||\
  [ ! -e $ksmroot/kbmessage ] ||\
  [ ! -e $ksmroot/kbmessage.sh ] ||\
  [ ! -e $ksmroot/onstart/ksmhome.sh ] ||\
  [ ! -e $ksmroot/onstart/poweroff.sh ] ||\
  [ ! -e $ksmroot/Qt/lib/libcommon.so ] ||\
  [ ! -e $ksmroot/Qt/lib/libQtCore.so.4 ] ||\
  [ ! -e $ksmroot/Qt/lib/libQtGui.so.4 ] ||\
  [ ! -e $ksmroot/Qt/lib/libQtNetwork.so.4 ] ||\
  [ ! -e $ksmroot/Qt/lib/libQtSvg.so.4 ] ||\
  [ ! -e $ksmroot/Qt/lib/libScreenManager.so ] ||\
  [ ! -e $ksmroot/Qt/lib/libSuspendManager.so ] ||\
  [ ! -e $ksmroot/Qt/plugins/gfxdrivers/libKoboFb.so ]
then
  echo "failed_important_file_missing"
  exit
fi

if [ ! -e $ksmroot/Qt/plugins/mousedrivers/$mousedriver ]; then
  cp $ksmuser/copyrepos/$mousedriver $ksmroot/Qt/plugins/mousedrivers/ 2>/dev/null
    if [ $? -gt 0 ]; then
    echo "failed_mousedriver_missing"
    exit
  fi
fi

echo "ok"
