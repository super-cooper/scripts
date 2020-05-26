#!/bin/bash
export PWD=/home/adam/dev/mongodb/mongo/

upstream=$(git --git-dir=$PWD/.git rev-parse --abbrev-ref "$branch@{upstream}" | sed 's/.*\///')
old_backport=$(echo $upstream | grep -e v3\. -e v4\.0)

if [ -z $old_backport ]; then
  env=/home/adam/.virtualenvs/mongo/bin/activate
else
  env=/home/adam/.virtualenvs/mongo_py2/bin/activate
fi

echo Using python: $env
source $env
$PWD/buildscripts/clang_format.py format $@
