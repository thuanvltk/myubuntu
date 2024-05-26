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
# Symbol
SUBSCRIPTION_SYMBOL=$'\U1F511'

az_ps1()
{
  AZ_SUBSCRIPTION=$(az account show 2> /dev/null | jq -r '.name')
  if [[ -n "$AZ_SUBSCRIPTION" ]]
  then
    echo -e "(${YELLOW}$SUBSCRIPTION_SYMBOL${CLEAR}|$AZ_SUBSCRIPTION)"
  else
    echo "(${YELLOW}$SUBSCRIPTION_SYMBOL${CLEAR})"
  fi
}