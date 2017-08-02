export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

source $SCRIPTS/colors.sh
source $SCRIPTS/git-completion.sh
source $SCRIPTS/real-easy.sh

export MONGODB_BIN_PATH=$DEVELOPMENT/mongodb/bin
export GAME_SIMULATOR_PATH=$DEVELOPMENT/git/fanx-game-simulator

export PATH=$MONGODB_BIN_PATH:$GAME_SIMULATOR_PATH:$PATH

alias sublime="open -a 'Sublime Text.app'"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES; killall -KILL Finder"
alias reload="source ~/.profile"
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo dns flushed"

alias redis="~/Development/redis/src/redis-server"
alias redis-cli="~/Development/redis/src/redis-cli"

alias nr="npm-run"

export PS1="\n$C_LIGHTGREEN\u $C_LIGHTGRAY@ $C_LIGHTGREEN\h $C_LIGHTGRAY: $C_LIGHTYELLOW\w $C_LIGHTCYAN"'$(__git_ps1 " (%s)")'"\n$C_LIGHTGRAY\$ $C_DEFAULT "

export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This actually loads nvm
