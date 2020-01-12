#!/bin/sh

# remove origin. wont help if url:s in commit message

git remote rm destination

# or remove url line in .git/config
git remote set-url origin ""

git remote -v
