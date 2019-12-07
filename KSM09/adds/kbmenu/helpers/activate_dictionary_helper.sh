#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

sqliteprog=$ksmroot/tools/sqlite3
database=/mnt/onboard/.kobo/KoboReader.sqlite
dictionary="$1"


languageCodeFile="${ksmuser}/txt/languageCodes.txt"
if [ ! -f "$languageCodeFile" ]; then
  echo "Error:_Cannot_find_language_code file"
  exit;
fi




if [ ! -f "$database" ]; then
  echo "Error:_Cannot_find_database"
  exit;
fi

dict_size=$(stat -c%s $dictionary)
dict_lastmodified=$(stat -c%y $dictionary)
dict_lastmodified=${dict_lastmodified%%.*}
dict_day=${dict_lastmodified%% *}
dict_time=${dict_lastmodified#*" "}
dict_lastmodified=$(echo $dict_day"T"$dict_time)

dictionary=$(basename $dictionary)
if [ "$dictionary" == "dicthtml.zip" ]; then
  dict_langCode1="en"
  dict_langCode2=""
else
  fname=${dictionary/".zip"/}
  dict_suffix=${fname/"dicthtml-"/}
  dict_langCode1=$(echo $dict_suffix | awk -F"-" '{print $1}')
  dict_langCode2=$(echo $dict_suffix | awk -F"-" '{print $2}')
  dict_langName1=$(awk -v key="$dict_langCode1" -F"=" '{if ($1 == key) {print $2}}' $languageCodeFile)
  if [ "$dict_langName1" == "" ]; then
    echo "undefined language code: $fname"
    exit
  fi
  if [ "$dict_langCode2" != "" ]; then
    dict_langName2=$(awk -v key="$dict_langCode2" -F"=" '{if ($1 == key) {print $2}}' $languageCodeFile)
    if [ "$dict_langName2" == "" ]; then
      echo "undefined language code: $fname"
      exit;
    fi
  fi
fi
dict_displayName=$dict_langName1
if [ "$dict_langName2" != "" ]; then
  dict_displayName="$dict_displayName - $dict_langName2"
fi

dict_suffix="-$dict_suffix"

$sqliteprog $database "replace into 'Dictionary' VALUES ('$dict_suffix', '$dict_displayName', 'true', '$dict_size', '$dict_lastmodified', 'true')"

echo "add $dict_displayName; sqlite exit code: $?"


