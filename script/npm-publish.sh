#!/bin/bash

# npm module hooks
alias pre-version='git diff --exit-code && npm prune && npm install -q && npm test && (npm run build; exit 0) && (git add .; git commit -m "release build"; exit 0)'
alias post-version='npm publish && git push && git push --tags && sync-package-description'

# use these to publish versions to npm
alias patch="pre-version && npm version patch && post-version"
alias feature="pre-version && npm version minor && post-version"
alias breaking="pre-version && npm version major && post-version"

pre_npm_versioner () {
	git diff --exit-code
	npm prune
	npm install -q
	npm test
	(npm run build; exit 0)
	(git add .; git commit -m "release build"; exit 0)
}

post_npm_versioner () {
	npm publish
	git push
	git push --tags
	sync-package-description
}

start_npm_versioner () {
	pre_npm_versioner
	npm version $1
	post_npm_versioner
}

np_patch () {
	start_npm_versioner patch
}

np_feature () {
	start_npm_versioner minor
}

np_breaking () {
	start_npm_versioner major
}
