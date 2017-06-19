export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

source $SCRIPTS/colors.sh
source $SCRIPTS/git-completion.sh
source $SCRIPTS/real-easy.sh

export NPM_GLOBAL_PATH=$DEVELOPMENT/npm_global/bin
export MONGODB_BIN_PATH=$DEVELOPMENT/mongodb/bin

export PATH=$NPM_GLOBAL_PATH:$MONGODB_BIN_PATH:$PATH

# useful commands
alias sublime="open -a 'Sublime Text.app'" # open a file in sublime text editor
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES; killall -KILL Finder" # show hidden files
alias reload="source ~/.profile" # reload this file
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo dns flushed" # flush dns cache

# installed apps
alias redis="~/Development/redis/src/redis-server"
alias redis-cli="~/Development/redis/src/redis-cli"

# shortcuts
alias qrcode=qrcode-terminal # create qrcode from given text
alias nr=npm-run # run with npm scoped environment
alias og=gh-home # open current folder in github if possible
alias on=npm-home # open current folder in npm if possible

export PS1="\n$C_LIGHTGREEN\u $C_LIGHTGRAY@ $C_LIGHTGREEN\h $C_LIGHTGRAY: $C_LIGHTYELLOW\w $C_LIGHTCYAN"'$(__git_ps1 " (%s)")'"\n$C_LIGHTGRAY\$ $C_DEFAULT "

export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
