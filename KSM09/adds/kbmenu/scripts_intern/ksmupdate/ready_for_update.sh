
ksmroot=${ksmroot:-"/adds/kbmenu"}

if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "script path: $0" >> $debug_logfile
  echo "ksmroot: $ksmroot" >> $debug_logfile
  echo "product: $PRODUCT" >> $debug_logfile
  echo "ksmGeometryValuesN: $ksmGeometryValuesN"  >> $debug_logfile
  echo "ksmGeometryValuesE: $ksmGeometryValuesE"  >> $debug_logfile
  echo "ksmGeometryValuesS: $ksmGeometryValuesS"  >> $debug_logfile
  echo "ksmGeometryValuesW: $ksmGeometryValuesW"  >> $debug_logfile
  sync
fi


localvol=/mnt/onboard
globalvol=/dev/root

historyfile=$ksmroot/updatehistory.txt

package="$1"


if [ ! -f "$historyfile" ]; then
  echo "error: cannot find $historyfile"
  exit
fi


available=$(cat "$historyfile")

pkgname=$(basename "$package")
pkgname="${pkgname%.zip}"

if echo "$available" | grep -q -F "+$pkgname"
then
  rm -f "$package"
  echo "deleted ${pkgname}.zip; you can install a package only once! "
  exit
fi

if [ "$(unzip -l "$package" | awk '{if($4=="instructions.txt") {print "ok"}}')" != "ok" ]; then
  echo "error: $package does not contain instructions.txt"
  exit
fi


available=$(echo $available)
instructions=$(unzip -p "$package" instructions.txt)
needed=$(echo "$instructions" | awk -F":" '{if ($1 == "required") {print $2}}')
missing=
IFS=$'\n'
for line in $needed
do
  IFS=' '
  result=false
  for word in $line
  do
    [ $result == true ] || [ -z "${available##*"+"$word[ ]*}" ] || [ -z "${available##*"+"$word}" ] && result=true
  done
  if [ $result == false ]; then
    [ "$missing" != "" ] && missing="$missing, "
    missing="$missing ${line// / or }"
  fi
  IFS=$'\n'
done

checkspace() {
  requiredspace=$1
  vol=$2
  case $requiredspace in
    ''|*[!0-9]*)
      echo "required space for $vol not correctly set"
      exit
      ;;
    *)
      availablespace=$(df -k "$vol" | awk -v vol=$vol '{if ($6 == vol) {print $4}}')
      if [ "$availablespace" -le "$requiredspace" ]; then
        echo "needed space on $vol: $requiredspace<br>available: $availablespace"
        exit
      fi
      ;;
  esac
  echo "ok"
}

if [ "$missing" == "" ]; then
  rls=$(echo "$instructions" | awk -F"=" '{if ($1 == "requiredlocalspace") {print $2; exit}}')
  checkresult=$(checkspace "$rls" "$localvol")
  if [ "$checkresult" != "ok" ]; then
    echo "$checkresult"
    exit
  fi
  rgs=$(echo "$instructions" | awk -F"=" '{if ($1 == "requiredglobalspace") {print $2; exit}}')
  checkresult=$(checkspace "$rgs" "$globalvol")
  if [ "$checkresult" != "ok" ]; then
    echo "$checkresult"
    exit
  fi
  echo "ok"
else
  echo "please install first $missing"
fi
