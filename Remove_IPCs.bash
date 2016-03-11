#!/usr/bin/env bash

##########################################
# SCRIPT: Remove_IPCs.bash
#
# AUTHOR: MunKeat
#   (Adapted from: http://stackoverflow.com/questions/2143404/delete-all-shared-memory-and-semaphores-on-linux)
#
# DATE: 11-NOV-2015
#
# PURPOSE: Cleanup semaphores and ICPs generated
##########################################

##########################################
# FILES AND VARIABLES DEFINITION(S)
##########################################
ME=$(whoami)

# ipcs -s: Print info about active semaphore(s).
IPCS_S=$(ipcs -s | grep "$ME" | awk '{ print $2 }')
# ipcs -m: Print info about active shared memory segment(s).
IPCS_M=$(ipcs -m | grep "$ME" | awk '{ print $2 }')
# ipcs -q: Print info about active message queue(s).
IPCS_Q=$(ipcs -q | grep "$ME" | awk '{ print $2 }')

##########################################
# MAIN BODY
##########################################
for id in $IPCS_M; do
  ipcrm -m $id;
done

for id in $IPCS_S; do
  ipcrm -s $id;
done

for id in $IPCS_Q; do
  ipcrm -q $id;
done
