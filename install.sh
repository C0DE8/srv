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

# installer title
echo "C0DE8 Server defaults Installer"

# clone main repository (bitbucket.org)
git clone https://beitsolutions@bitbucket.org/beitsolutions/server-defaults.git "${BASE_REPO_PATH}"

cd "${BASE_REPO_PATH}"
./install.sh
