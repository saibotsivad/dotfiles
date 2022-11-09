#!/bin/bash

# positional, e.g. `./setup.sh mylaptop` this would be `mylaptop`
export FLAVOR=${1}

export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles
export PROFILE_FLAVOR="${SCRIPTS}/profile-${FLAVOR}.sh"

# write the new profile file
cat > $PROFILE_FLAVOR <<- EOM
#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=\$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=${FLAVOR}

# bring on the profile
source \$SCRIPTS/profile.sh

# ========== per-computer customization after here ==========
EOM

chmod +x ${PROFILE_FLAVOR}

cat > $SCRIPTS/secrets.sh <<- EOM
#!/bin/bash

# These are all environment secrets. They should *never* be committed
# into a repo or exposed in any way! In fact, you should try to come
# up with a better way to store anything in here!

# ==================================================

# this is used by homebrew to be able to search
# generate a new one with
# https://github.com/settings/tokens/new?scopes=gist,public_repo&description=Homebrew
#export HOMEBREW_GITHUB_API_TOKEN=abc123
EOM

# symlink to the profile file
if [ -f "~/.profile" ]; then
    mv ~/.profile ~/.profile-$TIMESTAMP
else
    rm ~/.profile
fi
ln -s $SCRIPTS/profile-$FLAVOR.sh ~/.profile
