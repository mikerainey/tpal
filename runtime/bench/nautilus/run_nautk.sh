#!/usr/bin/env bash
###############################################################################
# Sane environemnt
###############################################################################
set -o pipefail -o noclobber -o errexit -o nounset
set -o xtrace

# the host on which to to build the binary
build_host="${build_host:-tinker-2}"

# the host on which to run and meter our binary
run_host="${run_host:-tinker-2}"

###############################################################################
# Build nautilus
###############################################################################

#controlled_host=${run_host} ./ipmi_helper.sh build

###############################################################################
# Set up log
###############################################################################

# clear out log
log=_results/results.txt
rm -f "${log}"
# if [ -e "${log}" ]
# then
# 	if [ -n "${delete:-}" ]
# 	then
# 		rm "${log}"
# 	else
# 		echo "${log} already exists!"
# 		echo "pass 'delete=1 ${0}' or pass a different version string"
# 		exit 1
# 	fi
# fi

###############################################################################
# run on remote host
###############################################################################

controlled_host=${run_host} ./ipmi_helper.sh restart
#set +o errexit
./drive_grub.py | tee -a "${log}"
#set -o errexit

controlled_host=${run_host} ./ipmi_helper.sh restart wait
