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

# make sure python installed programs are accessible
# install pip using `easy_install pip`
export PATH="/Users/tdavis/Library/Python/2.7/bin":$PATH

# used for 'localstack' an AWS emulator
# export SERVICES=apigateway,kinesis,dynamodb,dynamodbstreams,s3,lambda,sns,sqs,iam
export SERVICES=dynamodb

# setup anything custom
export GAME_SIMULATOR_PATH=$DEVELOPMENT/git/fanx-game-simulator
export PATH=$GAME_SIMULATOR_PATH:$PATH
alias chrome="open -a Google\ Chrome --args --disable-web-security --user-data-dir"
alias startdb="mongod --config /usr/local/etc/mongod.conf"
alias noder="node -r 'hard-rejection/register'"
alias faucet="node_modules/.bin/faucet"
alias fanx="node --max-old-space-size=8624 /Users/tdavis/Development/git/fanx-api-aws/bin/cli.js"
alias please="sudo"

alias ssh-stats-qa="ssh -i /Users/tdavis/.ssh/stats-ftp-qa-key.pem ubuntu@52.54.108.2"
alias ssh-stats-prod="ssh -i /Users/tdavis/.ssh/stats-ftp-key.pem ubuntu@52.45.84.160"
alias ssh-stats-prod-old="ssh -i /Users/tdavis/.ssh/stats-ftp-key.pem ubuntu@100.26.80.139"

alias ✅="echo \"🎉🎉🎉🎉 Ⓒ 👏 Ⓞ 👏 Ⓝ 👏 Ⓖ 👏 Ⓡ 👏 Ⓐ 👏 Ⓣ 👏 Ⓘ 👏 Ⓞ 👏 Ⓝ 🎉🎉🎉🎉\" && echo 🎉 Ⓨ Ⓞ Ⓤ 🎉 Ⓓ Ⓞ Ⓝ Ⓔ 🎉 Ⓘ Ⓣ 🎉"

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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
