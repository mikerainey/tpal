#!/usr/bin/env bash

# use:
# ./snip_ipmi_output.s <file-in> <file-out>

make snip_ipmi_output.dbg

file_in=$1
file_out=$2

cmd="./snip_ipmi_output.dbg -file $1"

$cmd > $file_out
