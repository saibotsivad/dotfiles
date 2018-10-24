#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=fno

# bring on the profile
source $SCRIPTS/profile.sh

# ========== do customization after here ==========

# setup rbenv, a ruby environment manager
# installation of `rbenv` is done with homebrew: `brew install rbenv`
# install a version of ruby: rbenv install 2.5.3
# after install need to do: rbenv rehash
# then install: gem install bundler
# inside a folder: bundle install
# e.g. NOT `bundler` it's `bundle`
eval "$(rbenv init -)"

# setup anything custom
export GAME_SIMULATOR_PATH=$DEVELOPMENT/git/fanx-game-simulator
export PATH=$GAME_SIMULATOR_PATH:$PATH
alias chrome="open -a Google\ Chrome --args --disable-web-security --user-data-dir"
alias startdb="mongod --config /usr/local/etc/mongod.conf"
