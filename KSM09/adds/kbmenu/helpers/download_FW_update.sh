
# guess maximal space requirement
available=$(df -k /mnt/onboard | awk '{if($6=="/mnt/onboard") {print $4}}')
if [ $available -le 120000 ]; then
  echo "there might be not enough free disk space"
  exit
fi



affiliates="Kobo Fnac RakutenBooks beta bestbuyca livrariacultura Eason WHSmith"
#affiliates="Kobo Fnac Rakuten"

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
targetdir=$ksmuser/fwrepository
mkdir -p "$targetdir"

modelnr=$1
currentFWversion=$2


getPaddedFWversion() {
  padit() {
    x=$1
    while [ ${#x} -lt 3 ]; do
      x="0"$x
    done
    echo $x
  }
  localVersion=$1
  part1=$(padit $(echo $localVersion | awk -F"." '{print $1}'))
  part2=$(padit $(echo $localVersion | awk -F"." '{print $2}'))
  part3=$(padit $(echo $localVersion | awk -F"." '{print $3}'))
  echo "$part1$part2$part3"
}




queryurlpre="http://api.kobobooks.com/1.0/UpgradeCheck/Device/00000000-0000-0000-0000-000000000$modelnr"
queryurlpost="$currentFWversion/N905xxxxxxxxx"

FWversion=0
bestURL=0

for aff in $affiliates
do
  xmlcontent=$(wget -q -O - "$queryurlpre/$aff/$queryurlpost")
  updateurl=$(echo "$xmlcontent" | awk 'match($0,/UpgradeURL.*zip/){print substr($0,RSTART+13,RLENGTH-13)}')
  if [ "$updateurl" != "" ]; then
    thisFWversion=$(echo "$updateurl" | awk 'match($0,/kobo-update-.*.zip/){print substr($0,RSTART+12,RLENGTH-16)}')
    thisFWversion=$(getPaddedFWversion $thisFWversion)
    if [ $thisFWversion -ge $FWversion ]; then
      FWversion=$thisFWversion
      bestURL=$updateurl
    fi
  fi
done


if [ "$bestURL" == "0" ]; then
  echo "no result"
  exit
fi

case $bestURL in
  */kobo3/* )
    mark="mark3_";;
  */kobo4/* )
    mark="mark4_";;
  */kobo5/* )
    mark="mark5_";;
  */kobo6/* )
    mark="mark6_";;
esac

savename=$(basename $bestURL)
savename=${savename/"kobo-update-"/}
savename="$mark$savename"


if [ -e "$targetdir/$savename" ]; then
  echo "$targetdir/$savename does already exist"
  exit
fi

export animationDurationS=10
$ksmroot/scripts_intern/div/on-animator.sh &

wget -O "$targetdir/$savename" "$bestURL"
theexitcode=$?
if [ "$theexitcode" -ne "0" ]; then
  echo "exit_code:_$theexitcode"
else
  echo "downloaded: $targetdir/$savename"
fi
killall on-animator.sh
