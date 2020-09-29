#!/usr/bin/env bash

benchdata=$1
linux_results=$2
nautilus_results=$3

benchdata_results_dst=$1/$(date +%s)

echo -n "Destination folder: $benchdata_results_dst"
mkdir $benchdata_results_dst

./collect_nautilus_results.sh $nautilus_results $benchdata_results_dst
cp $linux_results/results_*.txt $benchdata_results_dst

