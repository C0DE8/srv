#!/usr/bin/env bash
# shellcheck disable=SC1090

# Server Default Installer:
# (c) 2021 C0DE8

# Install with this command (from your Linux machine):
#
# curl -sSL https://install.c75x.de | bash

# -e option instructs bash to immediately exit if any command [1] has a non-zero exit status
# We do not want users to end up with a partially working install, so we exit the script
# instead of continuing the installation with something broken
set -e

# Set PATH to a usual default to assure that all basic commands are available.
# When using "su" an uncomplete PATH could be passed.
export PATH+=':/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

echo "#$1#"

# config
INSTALLER_VERSION="0.0.1"
INSTALLER_DATE="2021-01-25"
INSTALLER_TIME="11:30"
INSTALLER_RELEASE_DATE="${INSTALLER_DATE} (${INSTALLER_TIME})"
BASE_REPO_PATH="_srv-defaults"

# functions

# ensure that given string (command) exists on system
function ensureCommandExists {
  CMD="$1"
  if ! command -v "${CMD}" &> /dev/null
  then
      echo -e "${COL_LIGHT_RED} ERROR: command '${CMD}' could not be found! (exiting)${COL_NC}"
      exit 1
  else
      echo -e "${COL_LIGHT_GREEN}exists${COL_NC}"
  fi
}

function checkResult {
  if [ "$1" -eq 0 ]; then
    echo -ne "${SUCCESS}successful"
  else
    echo -ne "${ERROR}FAILED"
  fi
  echo -e "${DEFAULT}"
}

function cloneRepo {
  DISPLAY_NAME="$1"
  REPO_URL="$2"
  REPO_PATH="$3"

  echo -e "${WARNING}cloning ${DISPLAY_NAME}...${DEFAULT}"
  echo
  git clone "${REPO_URL}" "${REPO_PATH}"
  RESULT=$?
  echo
  echo -e "${WARNING}cloning" "$(checkResult "${RESULT}")"
  echo
}
#######

# If the color table file exists,
if [[ -f "${coltable}" ]]; then
    # source it
    source "${coltable}"
# Otherwise,
else
    # Set these values so the installer can still run in color
    COL_NC='\e[0m' # No Color
    COL_CYAN='\e[36m'
    COL_BLUE='\e[34m'
    COL_YELLOW='\e[33m'
    COL_LIGHT_BLUE='\e[94m'
    COL_LIGHT_GREEN='\e[1;32m'
    COL_LIGHT_YELLOW='\e[93m'
    COL_LIGHT_MAGENTA='\e[95m'
    COL_LIGHT_RED='\e[1;31m'
    TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
    CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
    INFO="[i]"
    # shellcheck disable=SC2034
    DONE="${COL_LIGHT_GREEN} done!${COL_NC}"
    OVER="\\r\\033[K"
fi

# installer title
echo
echo -e "${COL_CYAN}C0DE8 Server defaults Installer ${COL_LIGHT_YELLOW}v${INSTALLER_VERSION}${COL_BLUE}${COL_NC}"
echo -e "======================================\n"
echo -e "${COL_LIGHT_BLUE}Release: ${COL_YELLOW}${INSTALLER_RELEASE_DATE}${COL_BLUE}${COL_NC}\n"

NEEDED_CMD=( git )
for CMD in "${NEEDED_CMD[@]}"
do
   echo -ne "checking: ${COL_LIGHT_MAGENTA}${CMD}${COL_NC}..."
   ensureCommandExists "${CMD}"
done
echo

# clone main repository (bitbucket.org)
echo -e "cloning main repository...\n"
git clone https://bitbucket.org/beitsolutions/server-defaults.git "${BASE_REPO_PATH}"
echo "cloning completed: $(checkResult "$?)"

cd "${BASE_REPO_PATH}"
./install.sh
