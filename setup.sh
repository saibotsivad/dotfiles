#!/bin/bash

export TIMESTAMP=$(date +%s)

# symlink files
mv $HOME/.profile $HOME/.profile-$TIMESTAMP
ln -s $SCRIPTS/profile-$DOTFILE_FLAVOR.sh $HOME/.profile
