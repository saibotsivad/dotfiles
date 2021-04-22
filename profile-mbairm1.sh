#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=mbairm1

# bring on the profile
source $SCRIPTS/profile.sh

# ========== do customization after here ==========

# beginpm settings
# export BEGINPM_ROOT="$DEVELOPMENT/beginpm"
# or
# alias init="beginpm saibotsivad/beginpm-opinions"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
