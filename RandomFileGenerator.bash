#!/usr/bin/bash

##########################################
# SCRIPT: RandomFileGenerator.bash
#
# AUTHOR: MunKeat
#
# DATE: 11-NOV-2015
#
# PURPOSE: To generate a random file,
#   given the following parameters :-
#   (a) The new file name to be generated
#   (b) The size of the new file
##########################################

##########################################
# FUNCTION DEFINITION(S)
##########################################
generate_binary()
{
  # Verify that 2 parameters were entered
  if [[ "$#" -ne 2 ]]; then
    echo "Usage: generate_binary <filename> <size in bytes>"
    return
  fi

  filename=$1
  sizeInBytes=$2

  # dd: Copies a file, converting and formatting according
  # to the operands.

  # if: Input file
  # of: Output file
  # bs: Bytes to be read, and written at a time
  # count: Copy only BLOCKS input blocks

  # /dev/urandom is used instead of /dev/random
  # as as the latter has a very nasty problem: it blocks.
  dd if=/dev/urandom of="$filename" bs="$sizeInBytes" count=1
}

generate_alphanum()
{
  # Verify that 2 parameters were entered
  if [[ "$#" -ne 2 ]]; then
    echo "Usage: generate_alphanum <filename> <size in bytes>"
    return
  fi

  filename=$1
  sizeInBytes=$2

  # tr -dc : Delete everything that are not in the set [:alnum:]
  # tr -c: Complement the set of [:alnum:]
  # tr -d: Delete every occurance of the complement set of [:alnum:]

  # head -c: Reads the first X bytes (N.B. Option may not be available)
  tr -dc "[:alnum:]" < /dev/urandom | head -c "$2" > "$1"
}

##########################################
# MAIN BODY
##########################################
echo "Usage: ./RandomFileGenerator.bash <\"Optional: -b for binary\"> <filename> <size in bytes>"
