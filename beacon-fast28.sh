#!/bin/bash

alias rig="rigctl -m 370 -s 19200 -r /dev/ttyUSB0"
trap 'rig T 0' 0 1 2 3

set -e
rig T 0
rig F 28292222
rig F 28242400
rig F 28071111
rig F 28242400
rig M CW 250
rig L RFPOWER 0.1
rig L KEYSPD 15
rig G TUNE
sleep 8
rig T 1
sleep 1

while true
do
	date
	rig L RFPOWER 0.2
	rig L KEYSPD 15

	rig b "eclipse.yak.net cm97 "
	rig b "de w6rek/b"
	for x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 1 2 3 4 5 6 7 8 9 10 11 12
	do
		sleep 1
		echo "exit [expr { $(rig l SWR) > 1.2 }] " | tclsh
	done

	rig L KEYSPD 4
	rig L RFPOWER 0.5
	rig b T 
	sleep 1
	rig L RFPOWER 0.3
	rig b T 
	sleep 1 
	rig L RFPOWER 0.1
	rig b T
	sleep 1 
	rig L RFPOWER 0.03
	rig b T 
	sleep 1 
	rig L RFPOWER 0.01
	rig b T 
	sleep 1
	sleep 1
done
