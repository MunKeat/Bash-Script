#!/bin/env bash

##########################################
# SCRIPT: Snow.bash
#
# AUTHOR: MakeTechEasier
#   (Adapted from: https://www.maketecheasier.com/10-more-funny-andor-useless-linux-commands/)
#
# DATE: 22-AUG-2015
#
# PURPOSE: Animate snow falling
##########################################

##########################################
# FILES AND VARIABLES DEFINITION(S)
##########################################
LINES=$(tput lines)
COLUMNS=$(tput cols)

delayInSeconds=1

declare -A snowflakes
declare -A lastflakes

##########################################
# FUNCTION DEFINITION(S)
##########################################
function move_flake() {
  i="$1"

  if [ "${snowflakes[$i]}" = "" ] || [ "${snowflakes[$i]}" = "$LINES" ]; then
    snowflakes[$i]=0
  else
    if [ "${lastflakes[$i]}" != "" ]; then
      printf "\033[%s;%sH \033[1;1H " ${lastflakes[$i]} $i
    fi
  fi

  printf "\033[%s;%sH*\033[1;1H" ${snowflakes[$i]} $i

  lastflakes[$i]=${snowflakes[$i]}
  snowflakes[$i]=$((${snowflakes[$i]}+1))
}

##########################################
# MAIN BODY
##########################################
clear

while : ; do
  i=$(($RANDOM % $COLUMNS))

  move_flake $i

  for x in "${!lastflakes[@]}"; do
    move_flake "$x"
  done

  sleep $delayInSeconds
done
