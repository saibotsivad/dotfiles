#!/bin/bash

# load the main profile settings
export DEVELOPMENT=$HOME/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=mbairm1

# ========== do any specific setup here ==========

# ========== last thing, run the overall setup ==========
source $SCRIPTS/setup.sh
