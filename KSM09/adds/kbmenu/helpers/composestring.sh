#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}

### edit this part to change the selectable elements: start
alpha1options="A a B b C c D d E e"
alpha2options="F f G g H h I i J j"
alpha3options="K k L l M m N n O o"
alpha4options="P  p Q q R r S s T t"
alpha5options="U u V v W w X x Y y Z z"
otheroptions="[ ] {asterisk} {dot} {qmark} {space} {dash} {underscore} .epub .pdf .txt"

optionlist="${alpha1options// /} ${alpha2options// /} ${alpha3options// /} ${alpha4options// /} ${alpha5options// /} ${otheroptions// /}"
#### edit this part to change the selectable elements: end

composestring() {
  infotext=$1
  thisselectedoption=
  while [ "$thisselectedoption" != "EXIT" ]; do
    thisselectedoption=$($ksmroot/kobomenu.sh "-infotext=$infotext" -infolines=2 $2 accept cancle)
    case "$thisselectedoption" in
      accept )
        echo "$infotext"
        thisselectedoption="EXIT"
        ;;
      cancle )
        thisselectedoption="EXIT"
        echo ""
        ;;
      *)
        infotext="$infotext$thisselectedoption"
        ;;
    esac
  done
}


if [[ $# == 1 ]]; then
  infotext=$1
else
  infotext=
fi


selectedoption=

while [ "$selectedoption" != "EXIT" ]; do
#infotext=
#infotext=${infotext// /_}
  selectedoption=$($ksmroot/kobomenu.sh "-infotext=$infotext" -infolines=2 $optionlist clear find cancle)
  case "$selectedoption" in
    find )
      echo "$infotext"
      selectedoption="EXIT"
      ;;
    cancle )
      selectedoption="EXIT"
      echo ""
      ;;
    clear )
      infotext=
      ;;
    ${alpha1options// /})
      minfotext=$(composestring "$infotext" "$alpha1options")
      [ "$minfotext" != "" ] && infotext=$minfotext
      ;;
    ${alpha2options// /})
      minfotext=$(composestring "$infotext" "$alpha2options")
      [ "$minfotext" != "" ] && infotext=$minfotext
      ;;
    ${alpha3options// /})
      minfotext=$(composestring "$infotext" "$alpha3options")
      [ "$minfotext" != "" ] && infotext=$minfotext
      ;;
    ${alpha4options// /})
      minfotext=$(composestring "$infotext" "$alpha4options")
      [ "$minfotext" != "" ] && infotext=$minfotext
      ;;
    ${alpha5options// /})
      minfotext=$(composestring "$infotext" "$alpha5options")
      [ "$minfotext" != "" ] && infotext=$minfotext
      ;;
    ${otheroptions// /})
      minfotext=$(composestring "$infotext" "$otheroptions")
      [ "$minfotext" != "" ] && infotext=$minfotext
      ;;
    *)
      infotext="this should never happen"
      ;;
  esac
done
