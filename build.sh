#!/bin/bash

# Exit on error
set -e

# Define temp build directory
BUILD_DIR=/tmp/vite-build

# 1. Make sure you're on main
git checkout main

# 2. Stash uncommitted changes (just in case)
git stash push -m "WIP before build deploy"

# 3. Clean old temp build
rm -rf $BUILD_DIR

# 4. Run Vite build into /tmp
bun run build --outDir $BUILD_DIR

# 5. Switch to build branch
git checkout build

# 6. Clear current contents
git rm -rf .
git clean -fd

# 7. Copy the new build from /tmp into repo root
rsync -a $BUILD_DIR/ .

# 8. Commit and push
git add .
git commit -m "Update build"
git push origin build

# 9. Switch back and restore work
git checkout main
git stash pop
