#!/usr/bin/env bash

folder_out=$1

scp -i ~/.ssh/id_rsa_mac root@tinker-2.cs.iit.edu:/home/mrainey/tpal/runtime/nix/*.txt $folder_out
scp -i ~/.ssh/id_rsa_mac root@tinker-2.cs.iit.edu:/home/mrainey/tpal/runtime/nix/*.pdf $folder_out

# Transfer nautilus results

folder_nautilus_tmp=$(mktemp -d)
scp -i ~/.ssh/id_rsa_mac mrainey@subutai.cs.iit.edu:/home/mrainey/results_nautilus*.txt $folder_nautilus_tmp

for f in $(ls $folder_nautilus_tmp)
do
    d="$(basename -- $f)"
    echo "Transferring nautilus from $folder_nautilus_tmp/$f to $folder_out/$d"
    ./snip_ipmi_output.sh $folder_nautilus_tmp/$f $folder_out/$d
done

rm -rf $folder_nautilus_tmp

