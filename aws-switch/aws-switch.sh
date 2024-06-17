#!/usr/bin/env bash
# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
# Clear the color after that
CLEAR='\033[0m'

aws-switch(){
  PROFILE_ARR=($(aws configure list-profiles))
  for i in "${!PROFILE_ARR[@]}"
  do
    if [[ "${PROFILE_ARR[$i]}" == "$AWS_PROFILE" ]]
    then
      echo -e "* [$((i+1))]${YELLOW} ${PROFILE_ARR[$i]}${CLEAR}"
    else
      echo "  [$((i+1))] ${PROFILE_ARR[$i]}"
    fi
  done
  echo -n "Select AWS Profile to switch: "
  read -r AWS_PROFILE_SELECTED
  AWS_PROFILE_NUMBER=$((AWS_PROFILE_SELECTED-1))

  if [[ "${PROFILE_ARR[$AWS_PROFILE_NUMBER]}" != "" ]]
  then
    export AWS_PROFILE="${PROFILE_ARR[$AWS_PROFILE_NUMBER]}"
    echo "Active: $AWS_PROFILE"
  else
    echo "Value not in range! Not changing AWS Profile."
  fi
}