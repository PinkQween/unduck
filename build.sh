bun run build

git checkout build
git rm -rf .
mv dist/* .  # adjust path
git add .
git commit -m "Update build"
git push

git checkout main