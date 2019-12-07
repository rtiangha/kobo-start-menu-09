#!/bin/sh

# we could pass these value as cml parameters, but maybe for now this would be overkill 
vlautorun=CoolReader
applicationname=cr3



ksmroot=${ksmroot:-"/adds/kbmenu"}
vllauncherini=$vlasovsoftbasedir/launcher.ini
changed=false
oldautorun=
export startedAsAutorun=true;


# modify application script if necessary
if [ $(grep -c 'startedAsAutorun' "$vlasovsoftbasedir/${applicationname}.sh") -lt 1 ]; then
cat <<EOF > "$vlasovsoftbasedir/${applicationname}.sh"
#!/bin/sh
if [ "x\$startedAsAutorun" != "x" ]; then
  $applicationname/$applicationname -stylesheet \$STYLESHEET
  echo "exit" > \$VLASOVSOFT_FIFO1
else
  exec $applicationname/$applicationname -stylesheet \$STYLESHEET
fi
EOF

fi


# modify ini file if necessary
if [ $(grep -c '^autorun=${vlautorun}$' "$vllauncherini") -lt 1 ]; then
  changed=true
  oldautorun=$(grep "^autorun=" "$vllauncherini")
  case ${oldautorun} in
    autorun=*)
      sed -i "s/$oldautorun/autorun=$vlautorun/" "$vllauncherini"
      ;;
    *)
      echo "autorun=$vlautorun" >> "$vllauncherini"
      ;;
  esac
fi


# run launcher
$ksmroot/onstart/start_vlasovlauncher.sh

# restore autorun value
if [ "$changed" == "true" ]; then
  sed -i "s/autorun=$vlautorun/$oldautorun/" "$vllauncherini"
fi

