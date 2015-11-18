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
#   (3) Removing
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
  printf "%-25s %s\n" "Original" "Append"
  printf -- -----------------------------------------------"\n"
  for file in $FILES; do
    # Use printf to format output; %-10s will generate left-aligned; %10, right-aligned
    printf "%-25s %-25s\n" "$file" "$file$1"
  done
  printf -- -----------------------------------------------"\n"

  while : ; do
    read -p "Continue? (y/n) " confirmation

    case "$confirmation" in
      y | Y )
          break;;
      n | N )
          return;;
    esac
  done

  # Renaming
  for file in $FILES; do
    mv "$file"{,"$1"};
  done
}

prepend()
{
  # Verify that only 1 parameter was entered
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: prepend <string>"
    echo "Hint: Use 'Quotation' to encase your string."
    return
  fi

  # Confirmation
  printf "%-25s %s\n" "Original" "Prepend"
  printf -- -----------------------------------------------"\n"
  for file in $FILES; do
    printf "%-25s %-25s\n" "$file" "$1$file"
  done
  printf -- -----------------------------------------------"\n"

  while : ; do
    read -p "Continue? (y/n) " confirmation

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

remove()
{
  # Verify that only 1 parameter was entered
  if [[ "$#" -ne 1 ]]; then
    echo "Usage: remove <string>"
    echo "Hint: Use 'Quotation' to encase your string."
    return
  fi

  # Confirmation
  printf "%-25s %s\n" "Original" "Removed"
  printf -- -----------------------------------------------"\n"
  for file in $FILES; do
    if [[ "$file" =~ .*"$1".* ]]; then
      printf "%-25s %-25s\n" "$file" "${file/$1/}"
    fi
  done
  printf -- -----------------------------------------------"\n"

  while : ; do
    read -p "Continue? (y/n) " confirmation

    case "$confirmation" in
      y | Y )
          break;;
      n | N )
          return;;
    esac
  done

  # Renaming
  for file in $FILES; do
    if [[ "$file" =~ .*"$1".* ]]; then
      mv "$file" "${file/$1/}"
    fi
  done
}

replace()
{
  # Verify that only 1 parameter was entered
  if [[ "$#" -ne 2 ]]; then
    echo "Usage: replace <old> <new>"
    echo "Hint: Use 'Quotation' to encase your string."
    return
  fi

  # Confirmation
  printf "%-25s %s\n" "Original" "Replaced"
  printf -- -----------------------------------------------"\n"
  for file in $FILES; do
    if [[ "$file" =~ .*"$1".* ]]; then
      printf "%-25s %-25s\n" "$file" "${file/$1/$2}"
    fi
  done
  printf -- -----------------------------------------------"\n"

  while : ; do
    read -p "Continue? (y/n) " confirmation

    case "$confirmation" in
      y | Y )
          break;;
      n | N )
          return;;
    esac
  done

  # Renaming
  for file in $FILES; do
    if [[ "$file" =~ .*"$1".* ]]; then
      mv "$file" "${file/$1/$2}"
    fi
  done
}

##########################################
# MAIN BODY
##########################################
while : ; do
  # read -e: Permits autocomplete
  read -e -p "Enter command: " -a order

  if [[ "$order" =~ "cd .*" ]]; then
    # Recompute FILES variable
    FILES=$(echo "*")
  elif [[ "$order" = q ]]; then
    exit
  fi

  # Execute command
  "${order[@]}"
done
