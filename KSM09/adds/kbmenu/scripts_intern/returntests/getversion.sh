versionfilename=/mnt/onboard/.kobo/version

getPaddedFWversion () {
padit () {
x=$1
while [ ${#x} -lt 3 ]; do
    x="0"$x
done
echo $x
}
fwVersion=$(awk -F"," '{print $3}' $versionfilename)
part1=$(padit $(echo $fwVersion | awk -F"." '{print $1}'))
part2=$(padit $(echo $fwVersion | awk -F"." '{print $2}'))
part3=$(padit $(echo $fwVersion | awk -F"." '{print $3}'))
echo "$part1.$part2.$part3"
}

if [ -e $versionfilename ]; then
echo $(getPaddedFWversion)
else
echo "failed"
fi
