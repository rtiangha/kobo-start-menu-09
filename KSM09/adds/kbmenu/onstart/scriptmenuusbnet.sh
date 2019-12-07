#!/bin/sh

// check if there is ONE argument
if [[ $# != 1 ]]; then
  exit
fi

ksmroot=${ksmroot:-"/adds/kbmenu"}
. $ksmroot/onstart/exp_block

scriptsdir=$1

if [ -e $scriptsdir/help.txt ]; then
  infooption="info:help "
else
  infooption=""
fi

# ---------------------- function: set options
setoptions() {
  OIFS="$IFS"
  IFS=$'\n'
# ---------------------- find scripts
  scriptlist=""
  textlist=""
  for file in `find $scriptsdir -maxdepth 1 -name '*.sh'`
  do
    bar=${file/ /}
    bar=${bar/-/}
    if [ "$file" == "$bar" ]; then
      filename=$(basename $file)
      case $filename in
        usb_enable*.sh)
          if [ "$which_module" == "none" ]; then
            scriptlist="$scriptlist $(basename $file):execute.png"
            textlist="$textlist $(basename $file):help.png"
          fi
          ;;
        usb_disable*.sh)
          if [ "$which_module" == "usb" ]; then
            scriptlist="$scriptlist $(basename $file):execute.png"
            textlist="$textlist $(basename $file):help.png"
          fi
          ;;
        usbnet_toggle*.sh)
          if [ "$which_module" == "usbnet" ] || [ "$which_module" == "none" ]; then
            scriptlist="$scriptlist $(basename $file):execute.png"
            textlist="$textlist $(basename $file):help.png"
          fi
          ;;
      esac
    fi
  done
  IFS="$OIFS"
# ---------------------- create optionlist

  if [ "$scriptlist" != "" ]; then
    optionlist="exec/read:toggle.png"
    scriptlist=$(echo $scriptlist | xargs -n1 | sort | xargs)
    textlist=$(echo $textlist | xargs -n1 | sort | xargs)
    if [ "$toggleoption" == "execute_mode" ]; then
      optionlist="$optionlist $scriptlist"
    else
      optionlist="$optionlist $textlist"
    fi
  fi
}


# ---------------------- start the menu loop
toggleoption="execute_mode"
while [ "$menu" != "EXIT" ]; do
  which_module="none"
  MODULE_LOADED=`lsmod | grep -c g_file_storage`
  if [ $MODULE_LOADED -gt 0 ]; then
    statusinfo="USB support is enabled"
    which_module="usb"
  else
    MODULE_LOADED=`lsmod | grep -c g_ether`
    if [ $MODULE_LOADED -gt 0 ]; then
      statusinfo="USBNet support is enabled"
      which_module="usbnet"
    else
      statusinfo="neither USB nor USBNet support is currently enabled"
    fi
  fi
  setoptions
  menu=$($ksmroot/kobomenu -infolines=2 "-infotext=$statusinfo" $infooption$optionlist return:arrowup -qws)
  case "$menu" in
    info)
      $ksmroot/kbmessage.sh "-f $scriptsdir/help.txt"
      ;;
    exec/read)
      optionlist="exec/read:toggle.png"
      if [ $toggleoption == "execute_mode" ]; then
        optionlist="$optionlist $textlist"
        toggleoption="read_mode"
      else
        optionlist="$optionlist $scriptlist"
        toggleoption="execute_mode"
      fi
      ;;
    return)
      menu="EXIT";;
    *.sh)
      if [ "$toggleoption" == "execute_mode" ]; then
        $scriptsdir/$menu
      else
        $ksmroot/kbmessage.sh "-f $scriptsdir/$menu"
      fi
      ;;
    *)
      $ksmroot/onstart/scriptmenu.sh "$scriptsdir/$menu"
#
      ;;
  esac
done

