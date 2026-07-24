#!/bin/bash

# This is where everything lives.
export DEVELOPMENT=$HOME/Development
export DOTFILES=$DEVELOPMENT/dotfiles
export DOTFILE_LOGS=$DOTFILES/logs
export MODELS=$DEVELOPMENT/models

# ======== Disable Things =======
# Always disable analytics and other things before
# sourcing anything.
# ---
# Disable the macOS bash->zsh warning
export BASH_SILENCE_DEPRECATION_WARNING=1
# Disable AWS analytics
export SAM_CLI_TELEMETRY=0
# Disable turborepo / vercel analytics
export NEXT_TELEMETRY_DISABLED=1
# Silence the macOS warning
export BASH_SILENCE_DEPRECATION_WARNING=1
# Disable homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# ======== Scripts ========
# Bring on the scripts.
source $DOTFILES/script/colors.sh
source $DOTFILES/script/commit-folder-changes.sh
source $DOTFILES/script/git-completion.sh
source $DOTFILES/script/hass-active-meeting.sh
source $DOTFILES/script/download-youtube.sh
# Add the private bits last.
source $DOTFILES/secrets.sh

# ======== Path Setup ========
# Add things to the path, attempt to do so conditionally for
# applications and services that aren't always installed.
NOT_INSTALLED=()
add_path() {
	local dir="$1" label="${2:-}"
	if [ -d "$dir" ]; then
		export PATH="$dir:$PATH"
	elif [ -n "$label" ]; then
		NOT_INSTALLED+=("$label")
	fi
}
cmd_exists() {
	local cmd="$1" label="${2:-$1}"
	if command -v "$cmd" >/dev/null 2>&1; then
		return 0
	else
		NOT_INSTALLED+=("$label")
		return 1
	fi
}


# == Local bin folders ==
add_path "/usr/local/bin"
add_path "${HOME}/.local/bin"
add_path "${DOTFILES}/bin"
add_path "${DEVELOPMENT}/bins"

# == Node.js: JavaScript runtime ==
# Installer (manage Node.js versions using nvm): https://github.com/nvm-sh/nvm
# Software details: https://nodejs.org/
if [ -d "$HOME/.nvm" ] ; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# == Deno: JavaScript runtime ==
# Installer (manage deno versions using dvm): https://github.com/justjavac/dvm
# Software details: https://deno.com/
add_path "${HOME}/.dvm/bin" "Deno runtime"

# == Bun: JavaScript runtime ==
# Installer (manage bun versions using bvm): https://github.com/MrHacker26/bvm
# Software details: https://bun.com/
add_path "$HOME/.bun/bin" "Bun runtime"

# == Homebrew: Application installer for macOS ==
# Installer: https://brew.sh/
if [ -d "/opt/homebrew/bin" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Helper function to list installed packages.
function brewinfo () {
	echo "List all the things installed by homebrew."
	echo "left side = deps, right side = things using thing on left"
	brew list -1 | while read cask; do echo -ne "\x1B[1;34m $cask \x1B[0m"; brew uses $cask --installed | awk '{printf(" %s ", $0)}'; echo ""; done
}

# == Rancher: Docker container manager ==
# Installer: https://rancherdesktop.io/
add_path "${HOME}/.rd/bin" "Rancher (Docker container manager)"

# == OpenJDK: Open-source alternative to Java ==
# Install using homebrew.
# Software details: https://openjdk.org/
add_path "/opt/homebrew/opt/openjdk@17/bin" "OpenJDK"

# == Android Debugger ==
# Install to `$DEVELOPMENT/adb-fastboot/platform-tools`
add_path "$DEVELOPMENT/adb-fastboot/platform-tools" "Android debugger"

# == Go language compiler ==
# Software details: https://go.dev/
add_path "/usr/local/go/bin" "Golang"

# == Ruby language ==
# Install using RVM: https://rvm.io/
# Software details: https://www.ruby-lang.org/en/
# TODO have not validated as I haven't used Ruby in a long while
if [ -d "$HOME/.rvm" ] ; then
	export rvm_path="$HOME/.rvm"
	if [ -d "${rvm_path}/scripts/rvm" ] ; then
		source "${rvm_path}/scripts/rvm"
	fi
fi

# == Sublime Text Editor 3+ ==
# Install from: https://www.sublimetext.com/
add_path "/Applications/Sublime Text.app/Contents/SharedSupport/bin" "Sublime Text"

# == Sublime Merge ==
# Install from: https://www.sublimemerge.com/
add_path "/Applications/Sublime Merge.app/Contents/SharedSupport/bin" "Sublime Merge"

# == Rust Cargo package manager ==
# Install from: https://doc.rust-lang.org/cargo/
add_path "$HOME/.cargo/bin" "Rust Cargo"

# == LM Studio CLI ==
# Install from: https://lmstudio.ai/docs/cli
add_path "$HOME/.lmstudio/bin" "LM Studio CLI"

# Python via `pyenv` (install with `brew install pyenv`)
if [ -d "$HOME/.pyenv" ]; then
	export PYENV_ROOT="$HOME/.pyenv"
	add_path "${PYENV_ROOT}/bin" "Python (pyenv)"
	eval "$(pyenv init - bash)"
else
	NOT_INSTALLED+=("Python (pyenv)")
fi

# == eza file lister ==
# `eza` is a really powerful `ls` alternative
# Install with homebrew: brew install eza
# Software details: https://github.com/eza-community/eza
if cmd_exists eza; then
	alias ll="eza -1 -l -F --all --color-scale --group-directories-first --time-style=long-iso --git --header --group"
fi

# == Git Worktree ==
# Install from: http://forgejo.lan/saibotsivad/git-worktree
if [ -d "$DEVELOPMENT/git-clean" ]; then
	export WORKTREE_REPO_DIR="$DEVELOPMENT/wt/clean"
	export WORKTREE_SESSION_DIR="$DEVELOPMENT/wt/session"
	export WORKTREE_REMOTE_DIR="$DEVELOPMENT/wt/remote"
	export WORKTREE_CONFIGS_DIR="$DEVELOPMENT/wt/configs"
	source "$WORKTREE_REPO_DIR/git-worktree/wt.function.sh"
fi

# ======== Useful Commands ========

# == Dotfile Doctor ==
# Tells you what applications aren't installed/on the PATH.
dotfile_doctor() {
	if (( ${#NOT_INSTALLED[@]} > 0 )); then
		echo "Applications not installed/configured:" >&2
		printf '  - %s\n' "${NOT_INSTALLED[@]}" >&2
	fi
}

# == https://mosh.org/ ==
# Use mosh to start in a tmux session. If you have SSH aliases set up you can do:
#   tmosh myserver
# And if you want to start a named tmux session you just add the name:
#   tmosh myserver mymonitor
tmosh() {
	mosh "$1" -- tmux new-session -A -s "${2:-main}"
}

# Show all hidden files. Requires restarting finder.
alias showhidden="defaults write -g AppleShowAllFiles YES; killall -KILL Finder"
alias reload="source ~/.profile" # reload this file
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo dns flushed" # flush dns cache
alias gitpruneorigin="git remote prune origin" # clean removed branches
alias gitpruneupstream="git remote prune upstream" # clean removed branches
alias badchrome="open -a Google\ Chrome --args --disable-web-security --user-data-dir"

# Print out some handy formatted dates
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

# Immediately lock the screen, then do some wrapup tidying stuff.
# Alfred Workflow, add "Run Script" with bash: source /Users/tobiasdavis/.profile && lock_macos_computer
lock_macos_computer () {
	# This only sets the display to sleep, to make it also lock the screen
	# you need to update "System Settings > Lock Screen > Require password after screen saver..."
	# set this to "Immediately".
	pmset displaysleepnow
	# Make sure knowledge store is backed up.
	obsave
	# Kick off the appropriate HASS scene.
	curl \
		-H "Authorization: Bearer $HASS_TOKEN" \
		-H "Content-Type: application/json" \
		--request POST \
		--data '{"entity_id":"scene.leave_office"}' \
		"${HASS_URL}/api/services/scene/turn_on"
}

# Terminal colors (requires sourcing the colors file)
export PS1="$C_LIGHTGRAY\n$C_LIGHTGRAY\D{%Y-%m-%d}${C_CYAN}T$C_LIGHTGRAY\D{%H:%M:%S} $C_LIGHTGREEN\u$C_LIGHTGRAY@$C_LIGHTGREEN$DOTFILE_FLAVOR $C_LIGHTGRAY: $C_LIGHTYELLOW\w $C_LIGHTCYAN"'$(__git_ps1 "(%s)")'"\n$C_LIGHTGRAY\$ $C_DEFAULT "
