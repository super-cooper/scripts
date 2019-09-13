#!/bin/bash
export PWD=/home/adam/mongodb/mongo/

upstream=$(git --git-dir=/home/adam/mongodb/mongo/.git rev-parse --abbrev-ref "$branch@{upstream}" | sed 's/.*\///')
old_backport=$(echo $upstream | grep -e v3\. -e v4\.0)

if [ -z $old_backport ]; then
  env=/home/adam/.virtualenvs/mongo/bin/activate
else
  env=/home/adam/.virtualenvs/mongo_py2/bin/activate
fi

echo Using python: $env
source $env
"$HOME"/mongodb/mongo/buildscripts/clang_format.py format $@
