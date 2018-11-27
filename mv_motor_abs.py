#!/usr/bin/python
# -*- coding: utf-8 -*-
import time
import serial
import getopt
import sys
import math

def init_controler():
#	print "init"
	ser = serial.Serial(
		port='/dev/ttyUSB0',
		baudrate=9600,
		parity=serial.PARITY_NONE,
		stopbits=serial.STOPBITS_TWO,
		bytesize=serial.EIGHTBITS,
		timeout=10,
		xonxoff=0,
		rtscts=0)

#	ser.open()
	ser.isOpen()
	ser.flushOutput()
	ser.flushInput()
	return ser

def close_controler(ser):
#	print "close"
	write_slowly(ser, "\x1B", delay=0.3)
	ser.close()

def write_slowly(ser, cmdstring, delay=0.3):
#	print "write-slowly"
  for i in cmdstring:
	time.sleep(delay)
        ser.write(i)

#def read_slowly(ser, delay=0.3):
#	line = ''
#	lines= ''
#
#	while line!="P1":
#		for c in ser.read():
#			line += c
#			if c == '\n':
#				lines=line
#				line = ''
#				break
#			break
#	return(int(lines))

def read_slowly(ser, delay=0):
        line = ''
        lines= ''
        ss = 0
        while line!="P1":
                for c in ser.read():
                        if c == '\n':
                                lines=line
                                line = ''
                                if lines != '\r':
                                        if lines[:1] != "?":
                                                ss += int(lines)
                                break
                        else:
                                line += c
                        break

        return(int(ss))



def move_motor(ser,motor,steps):
	cmd="\x1B"+str(motor)+'X'+str(steps)+'\r\n'
	write_slowly(ser, cmd, delay=0.2)
	return  read_slowly(ser, 0.1)
	#return steps
	
def set_position(ser, mot, step):

	if float(step) > 0:
		directions = 1.0 
	else:
		directions = -1.0

	if mot == '6':
		errors = 596
		ratio = 12500
		unitt = 'deg'
		file_path = '/home/mar345/log/motor6.txt'

	elif mot == '4':
		errors = -20
		ratio = -20000
		unitt = 'mm'
		file_path = '/home/mar345/log/motor3.txt'

	elif mot == '2':
		errors = 20
		ratio = 400
		unitt = 'mm'
		file_path = '/home/mar345/log/motor2.txt'

	else:
		print ":: ERROR"
		exit()

	# czytamy aktualna pozycje silnika	
	file = open(file_path, 'r+')
	position_current_abs = float(file.read())
	position_new_abs = float(step)
	position_to_move = position_new_abs - position_current_abs
	floatstep=float(step)

	#print "MOTOR: [",mot,"] OLD POSITION: ",position_current_abs,"[",unitt,"] MOVE TO: ", floatstep, "[",unitt,"] :: ",position_to_move

	done_errpl = move_motor(ser, mot,    (   directions*int(errors)*0.5) )
	done_steps = move_motor(ser, mot, int(   ratio*position_to_move    ) )
	done_errmi = move_motor(ser, mot,    (-1*directions*int(errors)*0.5) )

	new_position = position_current_abs + (float(done_steps)/ratio)
	
	#print "MOTOR: [",mot,"] NEW POSITION: ",new_position,"[",unitt,"] DONE: ",done_steps/float(ratio),"[",unitt,"] :: e:",(done_errmi+done_errpl)
	print 	new_position, "  "
	
	file.seek(0)
	file.write("                 ")
	file.seek(0)
	file.write(str(new_position))
	file.close()
	return new_position
	
def save_log():
	text_file = open("/home/mar345/log/silnik.log", "a")
	txt=time.strftime("%Y:%m:%d-%H:%M:%S")+" :: MOTOR: "+str(motor)+" :: STEPS: "+str(stepss)+'\r\n'
	text_file.write(txt)
	text_file.close()


#--------------------------------------------------#
#-------- Here the actual program starts ----------#
#--------------------------------------------------#

#----- some parameters
delay = 0.3 # provide a reasonable default value...
delta = 1.0 # provide a reasonable default value...


# 1. Init controler
ser=init_controler()

# 2. Get motor and steps
stepss = 0
stepss = sys.argv[2]
motor  = 0 
motor  = sys.argv[1]

if stepss != 0 or motor != 0 :
	set_position(ser,motor,stepss)
else:
	print ":: error steps=0"

#set_zero_m1(ser)

close_controler(ser)

text_file = open("/home/mar345/log/silnik.log", "a")
txt=time.strftime("%Y:%m:%d-%H:%M:%S")+" :: MOTOR: "+str(motor)+" :: STEPS: "+str(stepss)+'\r\n'
text_file.write(txt)
text_file.close()

exit()

#--------------------------------------------------#
