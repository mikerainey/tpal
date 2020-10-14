#!/usr/bin/env bash

folder_in=$1
folder_out=$2

rm -f $folder_out/results_nautilus_heartbeat.txt

for f in $(ls $folder_in/*serial*)
do
    echo $f
    tmpfile=$(mktemp)
    ./snip_ipmi_output.sh $f $tmpfile
    cat $tmpfile >> $folder_out/results_nautilus_serial.txt
    rm -f $tmpfile
done	 

for f in $(ls $folder_in/*heartbeat*)
do
    if [[ "$f" != *"serial"* ]]; then
	echo $f
	tmpfile=$(mktemp)
	./snip_ipmi_output.sh $f $tmpfile
	cat $tmpfile >> $folder_out/results_nautilus_heartbeat.txt
	rm -f $tmpfile
    fi
done	 
