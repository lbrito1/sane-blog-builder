#!/bin/bash

# Compile output pages/assets
git checkout blog-dev
nanoc

# Temporarily stash changes
git stash

# Switch to Github Pages branch
git checkout blog-master
git rm * -r
git checkout blog-dev
git add .
git commit -m "Builds blog. (automated commit)"

# Push & deploy
git push blog/master blog-master

# Pop files
git checkout blog-dev
git stash pop
