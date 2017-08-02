#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=fno

# bring on the profile
source $SCRIPTS/profile.sh

# ========== do customization after here ==========

# setup anything custom
export GAME_SIMULATOR_PATH=$DEVELOPMENT/git/fanx-game-simulator
export PATH=$GAME_SIMULATOR_PATH:$PATH