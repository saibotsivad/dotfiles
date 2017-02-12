#!/bin/bash

# function re
# {
# 	if [[ $1 = "release" ]]; then
# 		if [[ $2 = "start" ]]; then
# 			#statements
# 		elif [[ $2 = "end" ]]; then
# 			#statements
# 		fi

# 		if [[ $3 = "major" ]]; then
# 			VERSION=
# 		fi
# 		if [[ $2 = "portal" ]]; then
# 			echo "Making release of fanx-portal-nodejs"
# 			pushd ~/Development/git/fanx-portal-nodejs
# 			git stash
# 			git fetch origin
# 			git checkout origin/develop
# 			npm prune
# 			npm install
# 			npm run test
# 			# npm run build # TODO someday we will get a build script
# 			bump $VERSION
# 			git add package.json
# 			git commit -m "feat: package.json $OLD_VERSION => $NEW_VERSION"
# 			git checkout -b release/$NEW_VERSION
# 			git push origin release/$NEW_VERSION
# 			read -p "Press [Enter] when the release branch is merged to master..."
# 			git tag -a r-$NEW_VERSION -m "Release: $NEW_VERSION" master
# 			git push --tags
# 			popd # return to previous folder
# 		elif [[ $2 = "api" ]]; then
# 			echo "Making release of fanx-api-nodejs"
# 		else
# 			echo "Unknown release. Supported: portal, api"
# 		fi
# 	fi
# }
