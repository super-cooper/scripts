#!/bin/bash

if [ -f /tmp/wtfconfig.yml ]; then
    rm /tmp/wtfconfig.yml
fi
cp ~/.config/wtf/config.yml /tmp/wtfconfig.yml
sed -Ei "s/github_api/$(/bin/cat ~/.config/github/api_keys/wtf_api_key)/g" /tmp/wtfconfig.yml
sed -Ei "s/todoist_api/$(/bin/cat ~/.config/todoist/api_key)/g" /tmp/wtfconfig.yml
