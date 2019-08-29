#!/bin/bash

# Compile output pages/assets
git checkout development
nanoc

# Temporarily stash changes
git stash

# Switch to Github Pages branch
git checkout master
git rm *
git checkout development -- output/
git add .
git commit -m "Builds blog. (automated commit)"

# Push & deploy
git push origin master

# Pop files
git checkout development
git stash pop
