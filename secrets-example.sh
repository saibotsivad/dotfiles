#!/bin/bash

# What you will need to do is copy this file:
#
#     cp secrets-example.sh secrets.sh
#
# And then you'll want to look through here and add
# any tokens or any other secrets that are required.

# ==================================================

# this is the auth token required for:
# https://www.npmjs.com/package/sync-package-description-cli
# see that module for more info on how to setup a token
export SYNC_PACKAGE_DESCRIPTION_AUTH='{"type":"token","token":"<TOKEN VALUE>"}'

# this is used by homebrew to be able to search
# generate a new one with
# https://github.com/settings/tokens/new?scopes=gist,public_repo&description=Homebrew
export HOMEBREW_GITHUB_API_TOKEN=abc123
