#!/bin/bash

# echo 'Before you run this command, see the setup instructions in this file.'
# Initial setup steps:
# * create a folder in your user folder like 'Dev'
# * symlink that to the unix home folder 'dev': `ln -s /mnt/c/Users/Tobias/Dev ~/dev`
# * create a folder in the Windows 'Dev' folder 'git' and then git clone 'dotfiles into it'
# when that's done, you're ready to run this file, comment out the exit line
# exit 1

# load the main profile settings
export DEVELOPMENT=$HOME/dev
export SCRIPTS=$DEVELOPMENT/git/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=hplaptop

# ========== do any specific setup here ==========

# ========== last thing, run the overall setup ==========
source $SCRIPTS/setup.sh
