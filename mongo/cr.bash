#!/bin/bash

# edit these variables so this script works for you
email=adam.cooper@10gen.com                                 # your email
venv=$HOME/.virtualenvs/mongo/bin/activate                  # path to your python3 virtual environment
cr_upload=$HOME/mongodb/kernel-tools/codereview/upload.py   # path to the kernel-tools upload.py file
browser=vivaldi                                             # command to open your internet browser

if [ -n "$(git --git-dir=$HOME/mongodb/enterprise/.git cherry -v)" ]; then
    yn=y
    if [ -n "$(git --git-dir=$HOME/mongodb/mongo/.git cherry -v)" ]; then
        printf "Detected modifications on both enterprise and community. Submit enterprise CR? "
        read yn
    fi

    if [ ${yn^^} == "Y" ] || [ ${yn^^} == "YES" ]; then
        cd $HOME/mongodb/enterprise
    fi
fi

# gets the name of the current checked-out branch
branch=$(git branch | grep "\*" | cut -d ' ' -f2)
if [ "$branch" == "master" ]; then
    echo "I won't put notes on master!!"
    exit 1
fi

# tries to obtain the ID of the code review from git-notes
id=$(git config branch.$branch.note 2> /dev/null | xargs echo)

# Stores the last git commit as message
message=""

# determines appropriate args based on whether an ID was found in git-notes
if [ -z "$id" ]; then
    echo -e "\033[1;92mCreating NEW review...\033[0;0m"
    other_args=( --email $email $@ -y --git_only_search_patch --git_similarity 75 --rev "$(git config branch.$branch.root)" )
else
    echo -e "\033[1;34mUpdating review...\033[0;0m"
    other_args=( $@ -y --git_only_search_patch --git_similarity 75 -i "$id" --rev "$(git config branch.$branch.root)" )
fi

# only check clang-format and eslint if not a backport
if [ -z "$(echo $branch | grep "BACKPORT")" ]; then
    other_args+=( --check-clang-format )
    other_args+=( --check-eslint )
fi

# submits the CR
output=$(source "$venv" && python3 "$cr_upload" ${other_args[@]} --title "$(git log -1 --pretty=%B | cut -d' ' -f2-)")
urlline=$(echo $output | grep URL:)
code=$?
if [ $code -ne 0 ]; then
    echo "Uploading code review failed ($code)"
    echo $output
    exit $code
fi

# extracts the URL and ID from the output of the code review submission
url=$(echo "$urlline" | sed -E 's/.+(https?.\/\/mongodbcr.appspot.com\/[0-9]+).*/\1/g')
id=$(echo "$url" | sed -E 's/.+\/([0-9]+).*/\1/g')

# stores the ID in the branch's git-notes
git config branch.$branch.note $id

# open the CR in the browser
$browser "$url" &> /dev/null
