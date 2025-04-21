#!/bin/bash

set -e

BUILD_DIR=/tmp/vite-build
rm -rf $BUILD_DIR

echo "🛠️ Building project..."
git checkout main
git stash push -m "WIP before build deploy"


bun i
bun run build --outDir $BUILD_DIR

echo "🚚 Switching to build branch..."
git checkout build

echo "🧹 Cleaning build branch..."
if [ -n "$(git ls-files)" ]; then
  git rm -rf .
fi
git clean -fd

echo "📦 Copying build from $BUILD_DIR..."
rsync -av $BUILD_DIR/ ./  # <-- verbose + correct slash

git add .
git commit -m "Update build" || echo "ℹ️ Nothing to commit."
git push origin build

echo "🔁 Switching back to main..."
git checkout main
git stash pop

echo "✅ Build branch updated successfully."
