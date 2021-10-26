#!/bin/bash
echo -n 'waiting'
while [ 1 -eq 1 ]
do
	ssh -q -o ConnectTimeout=8 ${1}
	echo -n '.'
	sleep 2
done
