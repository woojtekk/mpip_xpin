#!/bin/bash
clear
echo "----------------------------------"
echo "-         scan-ai_abs            -"
echo "-                                -"
echo "-       version: v.0.1           -"
echo "-          date: 08.12.2016      -"
echo "- zajaczkowski@mpip-mainz.mpg.de -"
echo "----------------------------------"
echo " "
echo "let it start ....."


pos_start=0    # strat position 
pos_stop =0    # stop position
pos_delta=0.05 # delta step
motor = 0

if [ -n $1]
then
motor=$1
else
echo ":: ERROR:: general error."
echo ":: please use command: "
echo ":: scan-ai-abs.sh [motor] [position start] [position_stop] [delta]"
exit
fi

if [ -n $2 ]
then
pos_start=$2
else
echo ":: ERROR:: general error."
echo ":: please use command: "
echo ":: scan-ai-abs.sh [motor] [position start] [position_stop] [delta]"
fi

if [ -n $3 ]
then
pos_stop=$3
else
echo ":: ERROR:: general error."
echo ":: please use command: "
echo ":: scan-ai-abs.sh [motor] [position start] [position_stop] [delta]"
fi

if [ -n $4 ]
then
pos_delta=$4
else
pos_delta=0.05
fi

echo "-----  parameters -----"
echo "MOTOR:          $motor"
echo "Start position: $pos_start"
echo "Stop position:  $pos_stop"
echo "delta:          $pos_delta"
echo "steps to do:    $steps"
echo "time to do:     $timetodo "
echo " "


motor=6
logfile="log_m"$motor"_ai.txt"

touch $logfile

steps=`echo "($pos_start - $pos_stopp)/$delta" | bc | sed -e "s/^\./0./" -e "s/^-\./-0./"`
echo $steps


i=0
position=$pos_start
while [ $i -le $steps ]
do
	echo "..."
	nname="agb_ai_"$pos
	mot=`mv_motor_abs.py $motor $pos`
	echo -e  $i "  \t " $mot " \t " $nname
	scan2.sh 5 $nname

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
