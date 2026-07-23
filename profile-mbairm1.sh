#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=mbairm1

# bring on the profile
source $SCRIPTS/profile.sh

# ========== do customization after here ==========

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/saibotsivad/.lmstudio/bin"
# End of LM Studio CLI section

# Python via `pyenv` (install with `brew install pyenv`)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

. "$HOME/.local/bin/env"
