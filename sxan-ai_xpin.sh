#!/bin/bash
clear
echo "----------------------------------"
echo "*         scan-ai_xpin           -"
echo "*                                -"
echo "*       version: v.0.1           -"
echo "*          date: 08.12.2016      -"
echo "* zajaczkowski@mpip-mainz.mpg.de -"
echo "*---------------------------------"
echo " "
echo "let it start ....."


pos_start=0    # strat position 
pos_stop=0    # stop position
pos_delta=0.5 # delta step
motor=0

if [ -n $1 ]
then
	motor=$1
else
	echo ":: ERROR:: general error."
	echo ":: please use command: "
	echo ":: scan-ai_xpin.sh [motor] [position start] [position_stop] [delta]"
	exit
fi

if [ -n $2 ]
then
	pos_start=$2
else
	echo ":: ERROR:: general error."
	echo ":: please use command: "
	echo ":: scan-ai_xpin.sh [motor] [position start] [position_stop] [delta]"
exit
fi

if [ -n $3 ]
then
	pos_stop=$3
else
	echo ":: ERROR:: general error."
	echo ":: please use command: "
	echo ":: scan-ai_xpin.sh [motor] [position start] [position_stop] [delta]"
exit
fi

if [ -n $4 ]
then
	pos_delta=$4
else
	pos_delta=0.5
fi

#*********************************
#*********************************
#*********************************

#pos_delta=0.01
steps=0
steps=`echo "($pos_start - $pos_stop)/$pos_delta" | bc | sed -e "s/^\././" -e "s/^-\./-./"`
if [ $steps -lt 0 ]
then
	steps=$((-1*steps))
fi

echo $steps

logfile="`pwd`/log_m"$motor"_`date "+%d.%m.%y"`.txt"
rm $logfile
touch $logfile
data=`date "+%d.%m.%y"`

echo "#-----  parameters ---------" >> $logfile
echo "#data:           $data      " >> $logfile
echo "#MOTOR:          $motor     " >> $logfile
echo "#Start position: $pos_start " >> $logfile
echo "#Stop position:  $pos_stop  " >> $logfile
echo "#delta:          $pos_delta " >> $logfile
echo "#steps to do:    $steps     " >> $logfile
echo "#Logfile:        $logfile   " >> $logfile
echo "#---------------------------" >> $logfile
echo "#                           " >> $logfile

echo "-----  parameters ---------"
echo "data:           $data      "
echo "MOTOR:          $motor     "
echo "Start position: $pos_start "
echo "Stop position:  $pos_stop  "
echo "delta:          $pos_delta "
echo "steps to do:    $steps     "
echo "Logfile:        $logfile   "
echo "---------------------------"
echo " "


#************ create gnuplot script
#************
gnufile="`pwd`/gnuplot.gnu"
xrl=$((pos_start-pos_delta))
xrp=$((pos_stop+pos_delta))
rm $gnufile
touch $gnufile
echo "reset"	                    				>>$gnufile
echo "set grid"                     				>>$gnufile
echo "set xrange [$xrl : $xrp]" 			>>$gnufile
echo "plot \"$logfile\" using 2:3"			 	>>$gnufile
echo "pause 1"                      				>>$gnufile
echo "reread"                       				>>$gnufile


#************  launch gnuplot
#************
gnuplot $gnufile &> /dev/null  &


#************ let start measurments
#************
echo -e "Position \t Counts"
position=$pos_start
i=0
while [ $i -le $steps ]
do
##	echo -e "$i \t  $((i*i))" >>$logfile
##	echo -e "$i \t  $((i*i))"
##	i=$((i+1))

        motpos=`silnik_quiet.py $motor $position`
        xpi=`xpin.py`

        echo -e $i"  \t " $motpos "  \t " $xpi >> $logfile
        echo -e $i"  \t " $motpos "  \t " $xpi

        position=`echo "$position + $pos_delta" | bc | sed -e "s/^\./0./" -e "s/^-\./-0./"`
#	echo "::  $position"
	i=$((i+1))

done






#************ wait for [ENTER] and close gnuplot and clean terminal
#************
read -p "Press [Enter] key to CLOSE all windows ..."
killall gnuplot
clear



