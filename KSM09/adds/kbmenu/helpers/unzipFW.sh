
ksmroot=${ksmroot:-"/adds/kbmenu"}
targetdir=/mnt/onboard/.kobo

if [[ $# != 2 ]]; then
  echo "incorrect_number_of_arguments"
  exit
fi

sourcefile=$1
mode=$2

if [ ! -e "$sourcefile" ]; then
  echo "source_file_does_not_exist"
  exit
fi

if [ ! -d "$targetdir" ]; then
  echo "target_directory_does_not_exist"
  exit
fi

# clean up
rm -f "$targetdir/KoboRoot.tgz"
rm -f "$targetdir/manifest.md5sum"
rm -rf "$targetdir/upgrade"

export animationDurationS=5

if [ "$mode" == "only_KoboRoot.tgz" ]; then
  $ksmroot/scripts_intern/div/on-animator.sh &
  unzip $sourcefile KoboRoot.tgz -o -qq -d "$targetdir"
  killall on-animator.sh
elif [ "$mode" == "complete" ]; then
  $ksmroot/scripts_intern/div/on-animator.sh &
  unzip $sourcefile -o -qq -d "$targetdir"
  killall on-animator.sh
else
  echo "incorrect_mode"
  exit
fi

echo "seems_to_have_worked"
