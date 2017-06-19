# use these to publish versions to npm
alias patch="pre-version && npm version patch && post-version"
alias feature="pre-version && npm version minor && post-version"
alias breaking="pre-version && npm version major && post-version"

# npm module hooks
alias pre-version='git diff --exit-code && npm prune && npm install -q && npm test && (npm run build; exit 0) && (git add .; git commit -m "release build"; exit 0)'
alias post-version='npm publish && git push && git push --tags && sync-package-description'
