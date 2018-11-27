#!/usr/bin/python
# -*- coding: utf-8 -*-
import time
import datetime
import serial
import getopt
import sys
import math
#import motor_mva as motor
#import xpin
import argparse
import os


def main():
	ff="/home/mar345/log/mar.spy"
	print tail(ff,5)
	
#def shuter_open():

#def shuter_close():

#def shuter_check_open():

#def shuter_check_close():


def tail(f, n, offset=0):
  stdin,stdout = os.popen2("tail -n "+n+offset+" "+f)
  stdin.close()
  lines = stdout.readlines(); stdout.close()
  return lines[:,-offset]

#    a=open('file.txt','rb')
#    lines = a.readlines()
#    if lines:
#        first_line = lines[:1]
#        last_line = lines[-1]



#------------------------------
#       start program
#------------------------------


if __name__ == '__main__':
    main()


