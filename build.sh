#!/bin/bash

set -e

BUILD_DIR=/tmp/vite-build

echo "🛠️ Building project..."
git checkout main
git stash push -m "WIP before build deploy"

rm -rf $BUILD_DIR

bun i
bun run build --outDir $BUILD_DIR

echo "🚚 Switching to build branch..."
git checkout build

# Avoid error if there are no files to remove
echo "🧹 Cleaning build branch..."
if [ -n "$(git ls-files)" ]; then
  git rm -rf .
fi
git clean -fd

echo "📦 Copying build from $BUILD_DIR..."
rsync -a $BUILD_DIR/ .

git add .
git commit -m "Update build"
git push origin build

echo "🔁 Switching back to main..."
git checkout main
git stash pop

echo "✅ Build branch updated successfully."
