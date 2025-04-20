#!/bin/bash

# Save your uncommitted changes
git stash push -m "WIP before build update"

# Switch to the build branch
git checkout build

# Clean out the branch (remove everything)
git rm -rf .
git clean -fd  # remove untracked files/directories too

# Copy everything from the dist folder into the root
rsync -a dist/ .

# Add and commit the updated build files
git add .
git commit -m "Update build"

# Push to remote
git push origin build

# Go back to main
git checkout main

# Restore your saved changes
git stash pop
