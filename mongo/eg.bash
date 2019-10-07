#!/bin/bash

shopt -s expand_aliases
export PWD=/home/adam/mongodb/mongo
alias evergreen=/home/adam/.local/bin/evergreen
branch=$(git branch | grep "\*" | cut -d ' ' -f2)
upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" | sed 's/.*\///')
id=$(evergreen patch -d "$(git current-branch)" -p mongodb-mongo-$upstream -y | grep ID | sed -E 's/.+ ([0-9]+)/\1/g')

if [ -n "$(git --git-dir=/home/adam/mongodb/enterprise/.git cherry -v)" ]; then
  cd $HOME/mongodb/enterprise && evergreen patch-set-module -i "$id" -m enterprise -y
fi

vivaldi "https://evergreen.mongodb.com/patch/$id" &> /dev/null
