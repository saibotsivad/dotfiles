#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=mbair

# bring on the profile
source $SCRIPTS/profile.sh

# ========== do customization after here ==========

# beginpm settings
# export BEGINPM_ROOT="$DEVELOPMENT/beginpm"
# or
# alias init="beginpm saibotsivad/beginpm-opinions"

alias cordova="../node_modules/cordova/bin/cordova"
