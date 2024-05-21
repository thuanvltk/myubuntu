#!/usr/bin/env bash
az_ps1()
{
  az_subscription=$(az account show 2> /dev/null | jq .name)
  if [[ -n "$az_subscription" ]]
  then
    echo "(🔑$az_subscription)"
  else
    echo "(🔑)"
  fi
}