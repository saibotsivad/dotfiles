#!/bin/bash

# disable the macOS bash->zsh warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# where everything lives
export DEVELOPMENT=$HOME/Development
export DOTFILES=$DEVELOPMENT/dotfiles
export DOTFILE_LOGS=$DOTFILES/logs

# bring on the scripts
source $DOTFILES/script/colors.sh
source $DOTFILES/script/commit-folder-changes.sh
source $DOTFILES/script/git-completion.sh
source $DOTFILES/script/hass-active-meeting.sh

# import the private bits
source $DOTFILES/secrets.sh

# anything to add to the path
export LOCAL_BIN="/usr/local/bin"
export MONGODB_BIN_PATH=$DEVELOPMENT/mongodb/bin
export NGROK_BIN_PATH=$DEVELOPMENT/ngrok
export RUBY_BIN_PATH=$HOME/.gem/ruby/2.3.0/bin
export PERSONAL_PATH_BINS=$DOTFILES/bin
export CUSTOM_BINS=$DEVELOPMENT/bins
export SUBLIME_PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin"
export CARGO_ENV="$HOME/.cargo/bin"

export PATH=$LOCAL_BIN:$MONGODB_BIN_PATH:$NGROK_BIN_PATH:$RUBY_BIN_PATH:$PERSONAL_PATH_BINS:$CUSTOM_BINS:$CARGO_ENV:$SUBLIME_PATH:$PATH

# TODO need to figure this out better, should run on all machines that have it
# setup rbenv, a ruby environment manager
# installation of `rbenv` is done with homebrew: `brew install rbenv`
# install a version of ruby: rbenv install 2.5.3
# after install need to do: rbenv rehash
# then install: gem install bundler
# inside a folder: bundle install
# e.g. NOT `bundler` it's `bundle`
# eval "$(rbenv init -)"
# export RVM_PATH="$HOME/.rvm/bin"
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# installed apps
#alias redis=$DEVELOPMENT/redis/src/redis-server
#alias redis-cli=$DEVELOPMENT/redis/src/redis-cli

# ======== brew install common =======
# tree

# ======== app shortcuts ========

alias ll="exa -1 -l -F --all --color-scale --group-directories-first --time-style=long-iso --git --header --group"
# https://github.com/ogham/exa
# install with homebrew: brew install exa

alias stree="open -a SourceTree ." # open SourceTree in current folder
# alias sublime="open -a 'Sublime Text.app'" # open a file in sublime text editor
alias badchrome="open -a Google\ Chrome --args --disable-web-security --user-data-dir"

# ======== useful commands ========

# Show all hidden files. Requires restarting finder.
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES; killall -KILL Finder"
alias reload="source ~/.profile" # reload this file
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo dns flushed" # flush dns cache
alias gitpruneorigin="git remote prune origin" # clean removed branches
alias gitpruneupstream="git remote prune upstream" # clean removed branches

# ======== deno =========
# manage deno versions using dvm, installation instructions here: https://deno.land/x/dvm@v1.5.5
# only add dvm if it's installed
if [ -d "$HOME/.dvm/bin" ] ; then
    export PATH="$HOME/.dvm/bin:$PATH"
fi

# ======== homebrew ========
# install here: https://brew.sh/
# add to shell
eval "$(/opt/homebrew/bin/brew shellenv)"
# helper
function brewinfo () {
    echo "List all the things installed by homebrew."
    echo "left side = deps, right side = things using thing on left"
    brew list -1 | while read cask; do echo -ne "\x1B[1;34m $cask \x1B[0m"; brew uses $cask --installed | awk '{printf(" %s ", $0)}'; echo ""; done
}
# disable homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# ======== other useful stuff ========

function jdate () {
    echo "
        const input = '${1}'
        if (/^[0-9]+$/.test(input)) {
            process.stdout.write(new Date(parseInt(input, 10) * 1000).toISOString())
        } else if (input) {
            process.stdout.write(Math.round(new Date(input).getTime() / 1000).toString())
        } else {
            const now = new Date()
            process.stdout.write(Math.floor(now.getTime() / 1000).toString() + '    ' + now.toISOString())
        }
    " | node
}

# disable aws analytics
export SAM_CLI_TELEMETRY=0

# disable turborepo / vercel analytics
export NEXT_TELEMETRY_DISABLED=1

# silence the mac warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# terminal colors
export PS1="$C_LIGHTGRAY\n$C_LIGHTGRAY\D{%Y-%m-%d}${C_CYAN}T$C_LIGHTGRAY\D{%H:%M:%S} $C_LIGHTGREEN\u$C_LIGHTGRAY@$C_LIGHTGREEN$DOTFILE_FLAVOR $C_LIGHTGRAY: $C_LIGHTYELLOW\w $C_LIGHTCYAN"'$(__git_ps1 "(%s)")'"\n$C_LIGHTGRAY\$ $C_DEFAULT "
# export PS1="$C_LIGHTGREEN\w \n$C_LIGHTGRAY\$ $C_DEFAULT "

# load node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# enable rancher if available, install from: https://rancherdesktop.io/
if [ -d "$HOME/.rd/bin" ] ; then
    export PATH="$PATH:$HOME/.rd/bin"
fi

# enable android debug tools if available
if [ -d "$DEVELOPMENT/adb-fastboot/platform-tools" ] ; then
    export PATH="$PATH:$DEVELOPMENT/adb-fastboot/platform-tools"
fi
