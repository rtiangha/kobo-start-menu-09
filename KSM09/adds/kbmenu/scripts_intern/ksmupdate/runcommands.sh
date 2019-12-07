

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
historyfile=$ksmroot/updatehistory.txt

package="$1"
commandtype="$2"

# already checked in ready_for_update.sh
#if [ "$(unzip -l "$package" | awk '{if($4=="instructions.txt") {print "ok"}}')" != "ok" ]; then
#  echo "error: $package does not contain required.txt"
#  exit
#fi

commands=$(unzip -p "$package" instructions.txt | grep "$commandtype":)

IFS=$'\n'
for command in $commands
do
  command=${command/$commandtype:/}
  eval "$command" > /dev/null 2>&1
done
