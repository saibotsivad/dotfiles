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

# ========== per-computer customization after here, but NOT SECRETS! those go in ./secrets.sh ==========

export YOUTUBE_MUSIC_FOLDER=~/Music/YouTube
export YOUTUBE_VIDEO_FOLDER=~/Movies/YouTube

# === ollama ===
# Go copy this to your specific profile and set parameters for your machine.
#   -ngl             Offload all layers to GPU (Metal). Use a high number to ensure nothing stays on CPU.
#   -c               Context window size (min 128K tokens). Reduce this if you're low on memory.
#   -np              Number of parallel slots. Keep at 1 for single-user use — more slots split your memory budget.
#   -fa              Flash attention. Reduces memory usage and speeds up long-context inference.
#   --cache-type-k   Quantize the key cache to 4-bit. This is the big memory saver.
#   --cache-type-v   Quantize the value cache to 4-bit. Together with the above, this cuts KV cache memory by ~75% vs f16.
#   --host 0.0.0.0   Listen on all interfaces. Use 127.0.0.1 if you don't need network access.
# export OLLAMA_MODEL=Qwen3.6-35B-A3B-Q4_K_M.gguf
# function start_ollama () {
#     llama-server -m ${MODELS}/${OLLAMA_MODEL} \
#         -ngl 99 \
#         -c 131072 \
#         -np 1 \
#         -fa on \
#         --cache-type-k q4_0 \
#         --cache-type-v q4_0 \
#         --host 0.0.0.0         
# }

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
