

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

package="$1"

if [ "$(unzip -l "$package" | awk '{if($4=="global.tgz") {print "ok"}}')" == "ok" ]; then
  globaltgzavailable=true
  if ! unzip -p "$package" global.tgz | gunzip -t > /dev/null 2>&1
  then
    echo "ERROR: uncompress global.tgz failed the test"
    exit
  fi
else
  globaltgzavailable=false
fi

if [ "$(unzip -l "$package" | awk '{if($4=="local.tgz") {print "ok"}}')" == "ok" ]; then
  localtgzavailable=true
  if ! unzip -p "$package" local.tgz | gunzip -t > /dev/null 2>&1
  then
    echo "ERROR: uncompress local.tgz failed the test"
    exit
  fi
else
  localtgzavailable=false
fi

if [ "$localtgzavailable" == "true" ]; then
  if ! unzip -p "$package" local.tgz |  tar zxf - -C "$ksmuser/" > /dev/null 2>&1
  then
    echo "ERROR: uncompress local.tgz failed"
    exit
  fi
fi

addmessage=""
if [ "$globaltgzavailable" == "true" ]; then
# install this part only on the device if the main version of KSM is running
  if [ "$ksmroot" == "/adds/kbmenu" ]; then
    if ! unzip -p "$package" global.tgz |  tar zxf - -C "/" > /dev/null 2>&1
    then
      echo "ERROR: uncompress global.tgz failed"
      exit
    fi
  else addmessage=" (skipped global.tgz)"
  fi
fi

pkgname=$(basename "$package")
pkgname="${pkgname%.zip}"
echo "+$pkgname" >> "$ksmroot/updatehistory.txt"
echo "$pkgname installed$addmessage"
