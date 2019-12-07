
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version
targetdir=$ksmuser/fwrepository
mkdir -p "$targetdir"

markvalue=$1
#currentFWversion=$2
currentFWversion=2.6.0

case $markvalue in
  mark3 ) models="310" ;;
  mark4) models="320 330 340 350" ;;
  mark5 ) models="360 370" ;;
  mark6 ) models="371 372 373 374 375 381" ;;
esac



getPaddedFWversion () {
padit () {
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

for model in $models
do
updateurl=$($helpers/get_FW_update_url.sh $model $currentFWversion)
if [ "$updateurl" != "" ]; then
thisFWversion=$(echo "$updateurl" | awk 'match($0,/kobo-update-.*.zip/){print substr($0,RSTART+12,RLENGTH-16)}')
thisFWversion=$(getPaddedFWversion $thisFWversion)


if [ $thisFWversion -ge $FWversion ]; then
  FWversion=$thisFWversion
  bestURL=$updateurl
fi
fi
done

# echo "$bestURL"

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

