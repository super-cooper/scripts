#!/bin/bash

upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" | sed 's/.*\///')
old_backport=$(echo $upstream | grep v3\.)

if [ -z $old_backport ]; then
  env=/home/adam/.virtualenvs/mongo/bin/activate
else
  env=/home/adam/.virtualenvs/mongo_py2/bin/activate
fi

source $env
"$HOME"/mongodb/mongo/buildscripts/clang_format.py format $@
