#!/bin/sh

# check if there is ONE argument
if [[ $# != 1 ]]; then
  exit
fi

ksmroot=${ksmroot:-"/adds/kbmenu"}
. $ksmroot/onstart/exp_block

scriptsdir=$1
if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "ksmroot: $ksmroot" >> $debug_logfile
  echo "scriptsdir: $scriptsdir" >> $debug_logfile
  echo "testKSMdebugmode: $testKSMdebugmode" >> $debug_logfile

fi



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
  for file in $(find $scriptsdir -maxdepth 1 -name '*.sh')
  do
    bar=${file/ /}
    bar=${bar/-/}
    if [ "$file" == "$bar" ]; then
      filename=$(basename $file)
      case $filename in
        wifi_enable*.sh)
          if [ "$modules_count" -lt 2 ]; then
            scriptlist="$scriptlist $(basename $file):execute.png"
            textlist="$textlist $(basename $file):help.png"
          fi
          ;;
        wifi_disable*.sh)
          if [ "$modules_count" -gt 0 ]; then
            scriptlist="$scriptlist $(basename $file):execute.png"
            textlist="$textlist $(basename $file):help.png"
          fi
          ;;
        *.sh)
              scriptlist="$scriptlist $(basename $file):execute.png"
              textlist="$textlist $(basename $file):help.png"
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
  let modules_count=0
  MODULE_LOADED=`lsmod | grep -c sdio_wifi_pwr.`
  if [ $MODULE_LOADED -gt 0 ]; then
    statusinfo="sdio_wifi_pwr.ko: loaded"
    let ++modules_count
  else
    statusinfo="sdio_wifi_pwr.ko: not loaded"
  fi
  MODULE_LOADED=`lsmod | grep -c ${WIFI_MODULE}`
  if [ $MODULE_LOADED -gt 0 ]; then
    statusinfo="$statusinfo <br>${WIFI_MODULE}.ko: loaded"
    let ++modules_count
  else
    statusinfo="$statusinfo <br>${WIFI_MODULE}.ko: not loaded"
  fi

  setoptions
  statusinfo=${statusinfo// /_}
  menu=$($ksmroot/kobomenu.sh -infolines=2 -infotext=$statusinfo $infooption$optionlist return:arrowup)
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
        childanswer=$($scriptsdir/$menu)
    [ "$KSMdebugmode" == "true" ] && echo "childanswer: $childanswer" >> $debug_logfile

        if [ "$childanswer" == "return_home" ]; then
          echo "return_home"
          menu="EXIT"
        fi
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

