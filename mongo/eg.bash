branch=$(git branch | grep "\*" | cut -d ' ' -f2)
upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" | sed 's/.*\///')
id=$(/home/adam/dev/scripts/evergreen patch -d "$(git current-branch)" -p mongodb-mongo-$upstream -y | grep ID | sed -E 's/.+ ([0-9]+)/\1/g')

if [ -n "$(git cherry -v)" ]; then
  /home/adam/dev/scripts/evergreen patch-set-module -i "$id" -m enterprise -y
fi

vivaldi "https://evergreen.mongodb.com/patch/$id"
