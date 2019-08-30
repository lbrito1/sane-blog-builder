#!/bin/bash

# Make sure we're in the correct dir
git checkout blog-dev

# Update remote
git add .
git commit -m "Updates development branch. (automated commit)"
git push blog blog-dev:development

# Compile output pages/assets
nanoc

# Switch to Github Pages branch
git checkout blog-master
git rm * -r

# Copy nanoc output to root
git checkout blog-dev output/
cp -r output/* ./
rm -rf ./output/*

# Send changes to remote (production branch)
git add .
git commit -m "Builds blog. (automated commit)"

# Push & deploy
git push blog blog-master:master

# Pop files
git checkout blog-dev
