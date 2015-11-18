#!/usr/bin/bash

##########################################
# SCRIPT: Rename.bash
#
# AUTHOR: MunKeat
#
# DATE: 19-NOV-2015
#
# PURPOSE: Mass renaming of files via:
#   (1) Appending
#   (2) Prepending
#   (3) Replacing
##########################################

##########################################
# FILES AND VARIABLES DEFINITION(S)
##########################################
FILES=$(echo "*")

##########################################
# FUNCTION DEFINITION(S)
##########################################
append()
{
  # Verify that only 1 parameter was entered
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: append <string>"
    echo "Hint: Use 'Quotation' to encase your string."
    return
  fi

  # Confirmation
  printf "%-25s %s\n" "Original" "Appended"
  printf -- -----------------------------------------------"\n"
  for file in $FILES; do
    # Use printf to format output; %-10s will generate left-aligned; %10, right-aligned
    printf "%-25s %-25s\n" "$file" "$1$file"
  done
  printf -- -----------------------------------------------"\n"

  while : ; do
    echo "Continue? (y/n)"
    read confirmation

    case "$confirmation" in
      y | Y )
          break;;
      n | N )
          return;;
    esac
  done

  # Renaming
  for file in $FILES; do
    mv {,"$1"}"$file";
  done
}

##########################################
# MAIN BODY
##########################################
