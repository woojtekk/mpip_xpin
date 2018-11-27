#!/bin/bash
clear
echo "zaczynamy ....."

i=0
pos_start=1
pos_stopp=-1
delta=0.05
pos=$pos_start

motor=3
logfile="log_m"$motor"_ko.txt"

touch $logfile

steps=`echo "($pos_start - $pos_stopp)/$delta" | bc | sed -e "s/^\./0./" -e "s/^-\./-0./"`
echo $steps

while [ $i -le $steps ]
do
	mot=`mv_motor_abs.py $motor $pos`
	xpi=`./xpin.py`

	echo -e  $i "  \t " $mot "  \t " $xpi >> $logfile
	echo -e  $i "  \t " $mot "  \t " $xpi

	i=$[$i+1]
	pos=`echo "$pos - $delta" | bc | sed -e "s/^\./0./" -e "s/^-\./-0./"`

done

#gnuplot <<- EOF
#	set xlabel "Position [mm] or [deg]"
#	set ylabel "Intensity"
#	set term png
#	set output "log_$motor.png"
#	plot $logfile using 2:3  title "bumtarara"
#EOF
#
#cp "log_$motor.png" /media/zaj/public_html/data/plot/
