#!/bin/bash

# These variables are useful in case you use a different repo for different branches
# E.g., I do that to push local branches to my personal blog's repo, which is
# different from this one.
local_development_branch="development"
local_master_branch="master"
remote="origin"

# Make sure we're in the correct dir
git checkout $local_development_branch

# Compile output pages/assets
ENV="production" # necessary for assets in production
nanoc

# Update remote
git add .
git commit -m "Updates development branch. (automated commit)"
git push $remote $local_development_branch:development

# Switch to Github Pages branch
git checkout $local_master_branch
git rm * -r

# Copy nanoc output to root
git checkout $local_development_branch output/ README.md
cp -r output/* ./
rm -rf ./output ./crash.log ./deploy.sh

# Send changes to remote (production branch)
git add .
git commit -m "Builds blog. (automated commit)"

# Push & deploy
git push $remote $local_master_branch:master

# Pop files
git checkout $local_development_branch
