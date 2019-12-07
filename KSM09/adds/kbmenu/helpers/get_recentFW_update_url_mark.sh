
ksmroot=${ksmroot:-"/adds/kbmenu"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version

markvalue=$1
#currentFWversion=$2
currentFWversion=2.6.0

case $markvalue in
  mark3 ) models="310" ;;
  mark4) models="320 330 340 350" ;;
  mark5 ) models="360 370" ;;
  mark6 ) models="371 372 373 374 375 381" ;;
  mark7 ) models="376 378 379" ;;
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

 echo "$bestURL"

