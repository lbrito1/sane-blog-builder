#!/bin/bash

# Make sure we're in the correct dir
git checkout blog-dev

# Update remote
git add .
git commit -m "Updates development branch. (automated commit)"
git push blog blog-dev:development

# Temporarily stash changes
git stash

# Compile output pages/assets
nanoc

# Switch to Github Pages branch
git checkout blog-master
git rm * -r
git checkout blog-dev output/
cp -r output/* ./
rm -rf ./output/*
git add .
git commit -m "Builds blog. (automated commit)"

# Push & deploy
git push blog blog-master:master

# Pop files
git checkout blog-dev
git stash pop
