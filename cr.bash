#!/bin/bash

# edit these variables so this script works for you
email=adam.cooper@10gen.com                                 # your email
venv=$HOME/mongodb/mongo/python3-venv/bin/activate          # path to your python3 virtual environment
cr_upload=$HOME/mongodb/kernel-tools/codereview/upload.py   # path to the kernel-tools upload.py file
browser=vivaldi                                             # command to open your internet browser

# gets the name of the current checked-out branch
branch=$(git branch | grep "\*" | cut -d ' ' -f2)
if [ "$branch" == "master" ]; then
    echo "I won't put notes on master!!"
    exit 1
fi

# tries to obtain the ID of the code review from git-notes
id=$(git config branch.$branch.note 2> /dev/null | xargs echo)

# determines appropriate args based on whether an ID was found in git-notes
if [ -z "$id" ]; then
    echo -e "\033[1;92mCreating NEW review...\033[0;0m"
    other_args=( --rev origin/master... -y --git_similarity 90 --check-clang-format --check-eslint --title $branch --email $email $@ )
else
    echo -e "\033[1;34mUpdating review...\033[0;0m"
    other_args=( -i "$id" --rev origin/master... -y --git_similarity 90 --check-clang-format --check-eslint --title $branch $@ )
fi

# submits the CR
output=$(source "$venv" && python3 "$cr_upload" ${other_args[@]} 2> /dev/null | grep URL:)
code=$?
if [ $code -ne 0 ]; then
    echo "Uploading code review failed ($code)"
    exit $code
fi

# extracts the URL and ID from the output of the code review submission
url=$(echo "$output" | sed -E 's/.+(http.+)/\1/g')
id=$(echo "$url" | sed -E 's/.+\/([0-9]+).*/\1/g')

# stores the ID in the branch's git-notes
git config branch.$branch.note $id &> /dev/null

# open the CR in the browser
$browser "$url" &> /dev/null
