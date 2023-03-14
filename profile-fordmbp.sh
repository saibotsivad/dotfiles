#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=fordmbp

# bring on the profile
source $SCRIPTS/profile.sh

# ========== per-computer customization after here ==========

obsave () {
	commit_folder_changes ~/Documents/Knowledge
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
