#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=example

# bring on the profile
source $SCRIPTS/profile.sh

# ========== do customization after here ==========
