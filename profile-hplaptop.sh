#!/bin/bash

# load the main profile settings
export DEVELOPMENT=$HOME/dev
export DOTFILES=$DEVELOPMENT/git/dotfiles

# bring on the scripts
source $DOTFILES/script/colors.sh
source $DOTFILES/script/git-completion.sh
source $DOTFILES/script/npm-publish.sh

# import the private bits
source $DOTFILES/secrets.sh

# anything to add to the path
export NGROK_BIN_PATH=$DEVELOPMENT/ngrok

export PATH=$NGROK_BIN_PATH:$PATH

# installed apps
# alias redis=$DEVELOPMENT/redis/src/redis-server
# alias redis-cli=$DEVELOPMENT/redis/src/redis-cli

# app shortcuts
alias stree="open -a SourceTree ." # open SourceTree in current folder
alias s="subl.exe" # open a file in sublime text editor

# useful commands
alias reload="source ~/.profile" # reload this file
alias gitclean="git remote prune" # clean removed branches, use like `gitclean origin` or `gitclean origin --dry-run` for a safer

# terminal colors
export PS1="\n$C_LIGHTGREEN\u $C_LIGHTGRAY@ $C_LIGHTGREEN\h $C_LIGHTGRAY: $C_LIGHTYELLOW\w $C_LIGHTCYAN"'$(__git_ps1 " (%s)")'"\n$C_LIGHTGRAY\$ $C_DEFAULT "
# alias ls='ls --color=auto'
# alias grep='grep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias egrep='egrep --color=auto'

# export LS_COLORS=$LS_COLORS:'di=0;35:'

# enable color support of ls/grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# load node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# enable android debug tools if available
# export PATH="$HOME/Development/adb-fastboot/platform-tools:$PATH"
