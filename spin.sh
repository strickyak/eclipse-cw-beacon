#!/bin/bash

function spin () {
	while sleep 0.3
	do
		t=`date +%s`
		r=`expr $t % 120`
		case $r in
			0 | 30 | 60 | 90 ) break ;;
		esac
	done
	echo $r
}

spin
