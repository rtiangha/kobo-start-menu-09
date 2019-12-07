#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

configureKSM() {
  configfile=$ksmroot/ksm_ini
  if [ -e $configfile ]; then
    while read p; do
      p="${p#"${p%%[![:space:]]*}"}"
      case "$p" in
        [*|export*|'#'* ) ;;
        *=|*=* )
          eval "$p" > /dev/null 2>&1
          ;;
      esac
    done <$configfile
  elif [ -f "${configfile}_template" ]; then
    cp "${configfile}_template" "$configfile"
  fi

### select font dir: begin
  fonttestdirs="$ksmFontDir \
  $ksmuser/fonts \
  $ksmroot/fonts"

  containsfont() {
    local result
    result="false"
    [ -d "$1" ] || exit
    for f in $(find "$1" -type f -maxdepth 1 -iname "*.ttf" -o -iname "*.otf")
    do
      result="true"
      break
    done
    echo $result
  }

  for dir in $fonttestdirs
  do
    if [ "$(containsfont "$dir")" == "true" ]; then
      ksmFontDir="$dir"
      break
    fi
  done

  echo $ksmFontDir
### select font dir: end
}
configureKSM
