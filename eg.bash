branch=$(git branch | grep "\*" | cut -d ' ' -f2)
upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" | sed 's/.*\///')
id=$(/home/adam/dev/scripts/evergreen patch -d "$(git current-branch)" -p mongodb-mongo-$upstream -y | grep ID | sed -E 's/.+ ([0-9]+)/\1/g')

git fetch

cd /home/adam/mongodb/mongo/src/mongo/db/modules/enterprise/ || exit
git pull --rebase origin $upstream

cd /home/adam/mongodb/mongo || exit
git pull --rebase origin $upstream

cd - || exit
if [ -n "$(git diff $branch $(git merge-base $branch origin/$upstream))" ]; then
  /home/adam/dev/scripts/evergreen patch-set-module -i "$id" -m enterprise -y
fi

vivaldi "https://evergreen.mongodb.com/patch/$id"
