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

# config
BASE_REPO_PATH="_srv-defaults"

# If the color table file exists,
if [[ -f "${coltable}" ]]; then
    # source it
    source "${coltable}"
# Otherwise,
else
    # Set these values so the installer can still run in color
    COL_NC='\e[0m' # No Color
    COL_CYAN='\e[36m'
    COL_LIGHT_GREEN='\e[1;32m'
    COL_LIGHT_RED='\e[1;31m'
    TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
    CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
    INFO="[i]"
    # shellcheck disable=SC2034
    DONE="${COL_LIGHT_GREEN} done!${COL_NC}"
    OVER="\\r\\033[K"
fi

# installer title
echo -e "${COL_CYAN}C0DE8 Server defaults Installer${COL_NC}\n"

# clone main repository (bitbucket.org)
git clone https://bitbucket.org/beitsolutions/server-defaults.git "${BASE_REPO_PATH}"

cd "${BASE_REPO_PATH}"
./install.sh
