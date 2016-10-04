#!/usr/bin/env bash


function emitter() {
	for N in 1 2 3 4 5 6 7 8 9 A B C D E; do
		echo "emit-$N"
		sleep 1;
	done
}

function consumer() {
	echo consumer started
	trap 'TARGET=null; echo consumer: swallow'	SIGUSR1
	trap 'TARGET=stdout; echo consumer: print to stdout' SIGUSR2
	while true; do
		while read LINE; do
			echo "consumer: consumed $LINE"
			if [ "x$TARGET" == xstdout ]; then
				echo "consumer: print $LINE"
			fi
		done
	done
}

emitter | consumer &
PID=$!

sleep 3
echo 'test: enable output'
kill -SIGUSR2 $PID

sleep 3
echo 'test: disable output'
kill -SIGUSR1 $PID

sleep 3
echo 'test: enable output again'
kill -SIGUSR2 $PID


sleep 3
kill $PID
