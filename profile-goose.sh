#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=goose

# bring on the profile
source $SCRIPTS/profile.sh

# ========== per-computer customization after here, but NOT SECRETS! those go in ./secrets.sh ==========
