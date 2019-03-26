#!/bin/bash

# Version of the extpack to be installed
PACK_VERSION_TO_INSTALL=5.2.12

# Version of the extpack that is already installed (if applicable)
PACK_VERSION_INSTALLED=`vboxmanage list extpacks | awk '/Oracle VM VirtualBox Extension Pack/ { getline; print $2 }'`

# Allow override of aborts when trying to install lower or same versions
FORCE=false

#
# Function Definitions
#

do_install () {
	echo "Going to install extpack version: $1";
	wget https://download.virtualbox.org/virtualbox/$1/Oracle_VM_VirtualBox_Extension_Pack-$1.vbox-extpack
	sudo VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-$1.vbox-extpack
}

# Compare dotted version numbers
# https://stackoverflow.com/questions/16989598/bash-comparing-version-numbers/24067243#24067243
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

usage () {
	echo "usage: $0 [[--force] [--version version ] | [--help|-h]]"
}

#
# Handle the Positional Parameters
#

while [ "$1" != "" ]; do
	case $1 in
		--force )			shift
							FORCE=true
							;;
		--version )			shift # shift off the key
							PACK_VERSION_TO_INSTALL=$1
							shift # shift off the value
							;;
		-h | --help )		usage
							exit
							;;
		* )					usage
							exit 1
	esac
done

#
# Main
#

# Only reinstall same version if --force was used
if [ "$PACK_VERSION_TO_INSTALL" == "$PACK_VERSION_INSTALLED" ] && \
   [ "$FORCE" == "false" ]
then
	echo "Version $PACK_VERSION_TO_INSTALL is already installed. To reinstall, use --force"
	exit
fi

# Only downgrade version if --force was used
if version_gt "$PACK_VERSION_INSTALLED" "$PACK_VERSION_TO_INSTALL" && \
   [ "$FORCE" ==  "false" ]
then
	echo "Will not downgrade to $PACK_VERSION_TO_INSTALL from $PACK_VERSION_INSTALLED without --force"
	exit
fi

# At this point either the extpack is not installed or a lower version
do_install $PACK_VERSION_TO_INSTALL
