#!/usr/bin/env bash

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
# FILES AND VARIABLES DEFINITION(S)
##########################################
binaryFlag="false"
fileName=""
filesize=0
numArg="${#}"
numOfFiles=1

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
  # as the latter has a very nasty problem: it blocks.
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
while : ; do
  if [[ "$numArg" -lt 2 ]] || [[ "$numArg" -gt 4 ]] || [[ "${#order[@]}" -lt 2 ]] || [[ "${#order[@]}" -gt 4 ]]; then
    numArg=2
    echo "Usage: ./RandomFileGenerator.bash <\"Optional: -b for binary\"> <filename> <size in bytes> <\"Optional: multiples of file(s)\">"
  else
    break
  fi

  read -p "Enter command: " -a order
done

# Extract binary flag, if present
if [[ ${order[0]} = "-b" ]]; then
  binaryFlag="true"
  # Shift
  unset order[0]
  order=( "${order[@]}" )
fi

# Extract file multiples
if [[ "${order[2]}" ]] && [[ "${order[2]}" -eq "${order[2]}" ]]; then
  numOfFiles="${order[2]}"
fi

# Extract remaining variables
fileName="${order[0]}"
filesize="${order[1]}"

if [[ "$numOfFiles" -gt 1 ]]; then
  for ((index = 0; index <= $numOfFiles ; index++)); do
    # Format number; new variable used as 0N is intepreted as hexadecimal
    indexing=$(printf %03d "$index")

    if [[ "$binaryFlag" = "true" ]]; then
      generate_binary "$fileName$indexing" "$filesize"
    else
      generate_alphanum "$fileName$indexing" "$filesize"
    fi
  done
else
  if [[ "$binaryFlag" = "true" ]]; then
    generate_binary "$fileName" "$filesize"
  else
    generate_alphanum "$fileName" "$filesize"
  fi
fi
