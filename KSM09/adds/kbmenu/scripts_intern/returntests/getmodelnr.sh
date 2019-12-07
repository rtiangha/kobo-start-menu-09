versionfilename=/mnt/onboard/.kobo/version

if [ -e $versionfilename ]; then
  model=$(awk -F"," '{print $6}' $versionfilename)
  model=$(echo $model | awk '{print substr($0,34,3)}')
  echo "$model"
else
  echo "failed"
fi
