#!/usr/bin/env bash

bench_data=$1
paper_repo=$2
machine=$3

dst=$paper_repo/$machine-$(date +%s)

echo -n "Destination folder: $dst"
mkdir $dst

cp $bench_data/results_*.txt $dst
cp $bench_data/results_*.csv $dst
cp $bench_data/tables_*.tex $dst
