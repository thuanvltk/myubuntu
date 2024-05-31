#!/usr/bin/env bash
set -uo pipefail;

####################################
# Ensure we can execute standalone #
####################################

function early_death() {
  echo "[FATAL] ${0}: ${1}" >&2;
  exit 1;
};

if [ -z "${TFENV_ROOT:-""}" ]; then
  # http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
  readlink_f() {
    local target_file="${1}";
    local file_name;

    while [ "${target_file}" != "" ]; do
      cd "${target_file%/*}" || early_death "Failed to 'cd \$(${target_file%/*})' while trying to determine TFENV_ROOT";
      file_name="${target_file##*/}" || early_death "Failed to '\"${target_file##*/}\"' while trying to determine TFENV_ROOT";
      target_file="$(readlink "${file_name}")";
    done;

    echo "$(pwd -P)/${file_name}";
  };
  TFENV_SHIM=$(readlink_f "${0}")
  TFENV_ROOT="${TFENV_SHIM%/*/*}";
  [ -n "${TFENV_ROOT}" ] || early_death "Failed to determine TFENV_ROOT";

else
  TFENV_ROOT="${TFENV_ROOT%/}";
fi;
export TFENV_ROOT;

if [ -n "${TFENV_HELPERS:-""}" ]; then
  log 'debug' 'TFENV_HELPERS is set, not sourcing helpers again';
else
  [ "${TFENV_DEBUG:-0}" -gt 0 ] && >&2 echo "[DEBUG] Sourcing helpers from ${TFENV_ROOT}/lib/helpers.sh";
  if source "${TFENV_ROOT}/lib/helpers.sh"; then
    log 'debug' 'Helpers sourced successfully';
  else
    early_death "Failed to source helpers from ${TFENV_ROOT}/lib/helpers.sh";
  fi;
fi;

# Ensure libexec and bin are in $PATH
for dir in libexec bin; do
  case ":${PATH}:" in
    *:${TFENV_ROOT}/${dir}:*) log 'debug' "\$PATH already contains '${TFENV_ROOT}/${dir}', not adding it again";;
    *)
      log 'debug' "\$PATH does not contain '${TFENV_ROOT}/${dir}', prepending and exporting it now";
      export PATH="${TFENV_ROOT}/${dir}:${PATH}";
      ;;
  esac;
done;

#####################
# Begin Script Body #
#####################

declare arg="${1:-""}";

log 'debug' "Setting TFENV_DIR to ${PWD}";
export TFENV_DIR="${PWD}";

abort() {
  log 'debug' 'Aborting...';
  {
    if [ "${#}" -eq 0 ]; then
      cat -;
    else
      echo "tfenv: ${*}";
    fi;
  } >&2;
};

log 'debug' "tfenv argument is: ${arg}";

case "${arg}" in
  "")
    log 'debug' 'No argument provided, dumping version and help and aborting';
    {
      tfenv---version;
      tfenv-help;
    } | abort && exit 1;
exit 1;
    ;;
  -v | --version )
    log 'debug' 'tfenv version requested...';
    exec tfenv---version;
    ;;
  -h | --help )
    log 'debug' 'tfenv help requested...';
    exec tfenv-help;
    ;;
  *)
    log 'debug' "Long argument provided: ${arg}";
    command_path="$(command -v "tfenv-${arg}" || true)";
    log 'debug' "Resulting command-path: ${command_path}";
    if [ -z "${command_path}" ]; then
      {
        echo "No such command '${arg}'";
        tfenv-help;
      } | abort && exit 1;
    fi;
    shift 1;
    log 'debug' "Exec: \"${command_path}\" \"$*\"";
    exec "${command_path}" "$@";
    ;;
esac;

log 'error' 'This line should not be reachable. Something catastrophic has occurred';
