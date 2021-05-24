#!/bin/bash

#touch test1.txt
#chmod a+x test1.txt
#git init
#prog=$(basename test1.txt)
prog=$(basename $0)
echo $prog
echo "Listing Files..."
ls -ltr
branch=$(git rev-parse --abbrev-ref HEAD)

if [ "$branch" == "master" ]; then
  echo Already on master. Exiting.
  exit 0
fi

need_to_stash=$(git status --porcelain|grep -v '^??')
if [[ $need_to_stash ]]; then
  git stash save "stashed by $prog"
fi
git checkout master
git fetch -p
git pull --ff-only
git checkout $branch

if [[ $(git rebase master) ]]; then
  if [[ $need_to_stash ]]; then
    git stash pop
  fi
else
  echo git rebase failed.
  if [[ $need_to_stash ]]; then
    echo You have changes stashed by $prog
  fi
fi
