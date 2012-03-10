#!/bin/sh
mpc clear
mpc load morning

mpc volume 0
mpc play
for vol in 10 20 30 40 50 60 70 80 90 100
do
	mpc volume $vol
	echo $vol volume
	sleep 3
done
#echo 'mpc stop'  | at now + 1 minute
