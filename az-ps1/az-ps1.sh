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
IAM_ROLE_SYMBOL=$'\U1F512'

aws_ps1()
{
  echo -e "(${YELLOW}$IAM_ROLE_SYMBOL${CLEAR}|$AWS_PROFILE)"
}