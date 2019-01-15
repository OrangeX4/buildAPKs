#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
JID=InDirs
NUM="$(date +%s)"
WDR="$PWD"
if [[ ! -z "${1:-}" ]]
then
	JID="$@"
fi
cd $HOME/buildAPKs
mkdir -p  "$HOME"/buildAPKs/var/log
if [[ ! -f "$HOME/buildAPKs/sources/applications/.git" ]]
then
	echo
	echo "Updating buildAPKs\; \`${0##*/}\` might need to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com"
	git pull
	git submodule update --init -- ./sources/applications
	git submodule update --init -- ./scripts/maintenance
	git submodule update --init -- ./docs
else
	echo
	echo "To update module ~/buildAPKs/sources/applications to the newest version remove the ~/buildAPKs/sources/applications/.git file and run ${0##*/} again."
fi

find $HOME/buildAPKs/sources/applications/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh Apps {} \; \ 
	2> "$HOME/buildAPKs/var/log/stnderr.build"$JID"."$NUM".log"

#EOF
