#!/bin/bash

# disable the macOS bash->zsh warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# where everything lives
export DEVELOPMENT=$HOME/Development
export DOTFILES=$DEVELOPMENT/dotfiles
export INKDROP_BACKUP_FOLDER=$DEVELOPMENT/inkdrop-sync

# bring on the scripts
source $DOTFILES/script/colors.sh
source $DOTFILES/script/git-completion.sh
source $DOTFILES/script/npm-publish.sh
source $DOTFILES/script/commit-inkdrop.sh

# import the private bits
source $DOTFILES/secrets.sh

# anything to add to the path
export LOCAL_BIN="/usr/local/bin"
export MONGODB_BIN_PATH=$DEVELOPMENT/mongodb/bin
export NGROK_BIN_PATH=$DEVELOPMENT/ngrok
export RUBY_BIN_PATH=$HOME/.gem/ruby/2.3.0/bin
export PERSONAL_PATH_BINS=$DOTFILES/bin
export CUSTOM_BINS=$DEVELOPMENT/bins
export CARGO_ENV="$HOME/.cargo/bin"

export PATH=$LOCAL_BIN:$MONGODB_BIN_PATH:$NGROK_BIN_PATH:$RUBY_BIN_PATH:$PERSONAL_PATH_BINS:$CUSTOM_BINS:$CARGO_ENV:$PATH


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

# app shortcuts
alias ll="exa -1 -l -F --all --color-scale --group-directories-first --time-style=long-iso --git --header --group" # https://github.com/ogham/exa
alias qrcode=qrcode-terminal # create qrcode from given text
alias ni="node $DOTFILES/cli.js setup-npm-module"
alias nr=npm-run # run with npm scoped environment
alias passphrase="generate-passphrase" # uses `generate-passphrase-cli`
alias og=gh-home # open current folder in github if possible
alias on=npm-home # open current folder in npm if possible
alias stree="open -a SourceTree ." # open SourceTree in current folder
alias sublime="open -a 'Sublime Text.app'" # open a file in sublime text editor
alias chrome="open -a Google\ Chrome --args --disable-web-security --user-data-dir"

# useful commands
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES; killall -KILL Finder" # show hidden files
alias reload="source ~/.profile" # reload this file
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo dns flushed" # flush dns cache
alias gitpruneorigin="git remote prune origin" # clean removed branches
alias gitpruneupstream="git remote prune upstream" # clean removed branches

function brewinfo () {
    echo "list all installed brew things"
    echo "left side = deps, right side = things using thing on left"
    brew list -1 | while read cask; do echo -ne "\x1B[1;34m $cask \x1B[0m"; brew uses $cask --installed | awk '{printf(" %s ", $0)}'; echo ""; done
}

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

# disable homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# disable aws analytics
export SAM_CLI_TELEMETRY=0

# silence the mac warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# terminal colors
export PS1="\n$C_LIGHTGRAY\D{%Y-%m-%d %H:%M:%S} $C_LIGHTGREEN\u $C_LIGHTGRAY@ $C_LIGHTGREEN\h $C_LIGHTGRAY: $C_LIGHTYELLOW\w $C_LIGHTCYAN"'$(__git_ps1 "(%s)")'"\n$C_LIGHTGRAY\$ $C_DEFAULT "

# load node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# enable android debug tools if available
if [ -d "$HOME/Development/adb-fastboot/platform-tools" ] ; then
	export PATH="$HOME/Development/adb-fastboot/platform-tools:$PATH"
fi
