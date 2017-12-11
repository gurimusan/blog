#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
docker run --rm -it -v "$PWD":/home/gurimusan/blog -w /home/gurimusan/blog gurimusan/blog hugo

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
git subtree push --prefix=public git@gurimusan_github:gurimusan/blog.git gh-pages