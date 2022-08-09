#!/usr/bin/gnuplot
reset
#comment

#set terminal x11
set terminal jpeg
set output "output.jpg"

plot "./timelog2.txt" u 2:3

#pause -1
