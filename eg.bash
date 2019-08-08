branch=$(git branch | grep "\*" | cut -d ' ' -f2)
id=$(/home/adam/dev/scripts/evergreen patch -d "$(git current-branch)" -y | grep ID | sed -E 's/.+ ([0-9]+)/\1/g')
cd /home/adam/mongodb/mongo/src/mongo/db/modules/enterprise/ || exit
git pull --rebase origin master
git checkout master
git pull --rebase origin master
git checkout -
cd /home/adam/mongodb/mongo || exit
git pull --rebase origin master
git checkout master
git pull --rebase origin master
git checkout -
cd - || exit
if [ -n "$(git diff $branch $(git merge-base $branch master))" ]; then
  /home/adam/dev/scripts/evergreen patch-set-module -i "$id" -m enterprise -y
fi
vivaldi "https://evergreen.mongodb.com/patch/$id"
