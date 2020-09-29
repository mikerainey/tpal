#!/usr/bin/env bash

# use:
# ./snip_ipmi_output.sh <file-in> <file-out>

make snip_ipmi_output.dbg

file_in=$1
file_out=$2

tmpfile=$(mktemp)

dos2unix -f -n $file_in $tmpfile

cmd="./snip_ipmi_output.dbg -file $tmpfile"

$cmd > $file_out

rm -f $tmpfile
