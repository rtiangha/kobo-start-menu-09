#!/bin/sh

startdir=/mnt/onboard
[ "$1" != "" ] && startdir="$1"

#export mrotation=180
ksmroot=${ksmroot:-"/adds/kbmenu"}
koreadersh=$ksmroot/onstart/start_koreader_args.sh
composesh=$ksmroot/helpers/composestring.sh

optionlist=
rawsearchpattern=
searchpattern=$($composesh)
rawsearchpattern=$searchpattern
searchpattern=${searchpattern//\{asterisk\}/*}
searchpattern=${searchpattern//\{dot\}/.}
searchpattern=${searchpattern//\{qmark\}/?}
searchpattern=${searchpattern//\{space\}/ }
searchpattern=${searchpattern//\{dash\}/-}
searchpattern=${searchpattern//\{underscore\}/_}

cd "$startdir"

if [ "$searchpattern" != "" ]; then
  OIFS="$IFS"
  IFS=$'\n'
#for file in $(find $startdir -type f -name "$searchpattern")
  for file in $(find . -type f -name "$searchpattern" | head -100)
  do
#optionlist='$optionlist "$file"'
# optionlist="$optionlist $file"
    thefile=${file/./}
    optionlist="$optionlist ${thefile// /&20}"
  done
  IFS="$OIFS"
fi

selectedoption=
#infotext="$searchpattern"
#infotext="$rawsearchpattern"
toggleoptiontext="info/open_in_koreader"
toggleoption="info"
#infotext=$toggleoption
infotext="current_mode:_$toggleoption"
while [ "$selectedoption" != "EXIT" ]; do
  selectedoption=$($ksmroot/kobomenu.sh -infolines=2 "-infotext=$infotext" $toggleoptiontext:toggle.png $optionlist new_search:execute.png return:arrowup.png return_home:arrowup.png)
  case "$selectedoption" in
    return)  selectedoption="EXIT";;
    return_home)
      selectedoption="EXIT"
      echo "return_home"
      ;;
    help)
      $ksmroot/kbmessage.sh "-f $workingdir/help.txt"
      ;;
    new_search)
      optionlist=
      searchpattern=$($composesh "$rawsearchpattern")
      rawsearchpattern=$searchpattern
      searchpattern=${searchpattern//\{asterisk\}/*}
      searchpattern=${searchpattern//\{dot\}/.}
      searchpattern=${searchpattern//\{qmark\}/?}
      searchpattern=${searchpattern//\{space\}/ }
      searchpattern=${searchpattern//\{dash\}/-}
      searchpattern=${searchpattern//\{underscore\}/_}
      if [ "$searchpattern" != "" ]; then
        OIFS="$IFS"
        IFS=$'\n'
        for file in $(find . -type f -name "$searchpattern" | head -100)
        do
          thefile=${file/./}
          optionlist="$optionlist ${thefile// /&20}"
        done
        IFS="$OIFS"
      fi
      ;;
    $toggleoptiontext)
      case $toggleoption in
        info)
          toggleoption=open_in_koreader
          infotext="current_mode:_$toggleoption"
          ;;
        open_in_koreader)
          toggleoption=info
          infotext="current_mode:_$toggleoption"
          ;;
      esac
      ;;

    *)
#    infotext="$selectedoption"
      if [ "$toggleoption" == "open_in_koreader" ];then
        if [ ! -e "$startdir$selectedoption" ]; then
          selectedoption=${selectedoption//&20/ }
        fi
        if [ -e "$startdir$selectedoption" ]; then
          $koreadersh "$startdir$selectedoption"
        else
          infotext="Did_not_work._Presumably_the_script_cannot_handle_some_characters_of_ the_filename"
        fi
      else
        infotext="$startdir$selectedoption"
      fi
      ;;
  esac
done



