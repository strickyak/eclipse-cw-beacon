SCHED='28071111:80 14071111:80 7071111:80 3571111:30'
SCHED='3571111:50'
SCHED='28071111:80 14071111:80 7071111:80 3571111:50'
SCHED='28071111:10 14071111:10 7071111:10 3571111:10'

SCHED='28087000:50 14087000:80 7087000:80 3587000:50'
SCHED='28087000:10 14087000:10 7087000:10 3587000:10'
SCHED='28087000:40 14087000:40 7087000:40 3587000:40'

SCHED='28087000:30 14087000:30 7087000:30 3587000:30'
SCHED='28087000:20 14087000:20 7087000:20 3587000:20'

alias rig="rigctl -m 370 -s 19200 -r /dev/ttyUSB0"
trap 'rig T 0' 0 1 2 3

S=8
S=4
set -e
while true
do
	for sched in $SCHED
	do
		set / $(echo $sched | tr ':' ' ')
		F0=$2
		P=$3

		#F=$(echo '''
		#	proc tweak {f} {
		#		set m [expr {[clock format [clock seconds] -format 1%M] % 10}]
		#		puts [expr { $f - 450 + 100*$m }]
		#	}
		#	tweak ''' $F0 | tclsh)
		F=$(echo "puts [expr 111+$F0]" | tclsh)

		case `date +%H%M` in
		  *0 | *1 ) R=12 ;;
		  *2 | *3 ) R=14 ;;
		  *4 | *5 ) R=16 ;;
		  *6 | *7 ) R=18 ;;
		  *8 | *9 ) R=20 ;;
		esac

		date
		echo "T 0
F $F
M CW 250
M CW 500
L RFPOWER $(echo "puts [format %.2f [expr 0.01+$P/100.0]]" | tclsh)
L KEYSPD 20
T 0
" | rig -
		sleep 1
		rig G TUNE
		sleep $S

		rig L KEYSPD $R
		rig T 1
		rig b "de w6rek/b w6rek/b"
		rig b "yak.net"

		while [ 1 = "$(rig t)" ]  # Stop when done transmitting morse.
		do
			echo "exit [expr { $(rig l SWR) > 1.3 }] " | tclsh
			sleep 1
			rig T 0  # attempt to turn off, when done transmitting morse.
		done


		set 0 $(echo "set p $P " '''
			proc fn {x} {
			  set z [expr {$::p * $x}]
			  if {$z < 1} {set z 1}
			  format %10.02f [expr {$z/100.0}]
			}
			puts "[fn 1] [fn 0.3] [fn 0.1] [fn 0.03] [fn 0.01]"
		''' | tclsh)
		shift
		case $# in
			5) : ok ;;
			*) echo "Bad powers: $#: $*" >&2; exit 13 ;;
		esac
		: POWERS : $* :

		rig T 1
		rig L KEYSPD 4
		rig L RFPOWER $1
		rig b T 
		sleep 1
#		rig L RFPOWER $2
#		rig b T 
#		sleep 1 
		rig L RFPOWER $3
		rig b T
		sleep 1 
#		rig L RFPOWER $4
#		rig b T 
#		sleep 1 
		rig L RFPOWER $5
		rig b T 
		sleep 1
#		sleep 1
		rig T 0
	done
done

