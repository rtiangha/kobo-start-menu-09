
#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
imagepath=$ksmroot/images

reps=$1
delay=$2

while :
do
  $ksmroot/kbimageviewer.sh -showandexit -repetitions=$reps -delay=$delay $imagepath/arrow0.png $imagepath/arrow1.png $imagepath/arrow2.png $imagepath/arrow3.png
done
