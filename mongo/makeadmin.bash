#!/bin/bash

cd $HOME/mongodb/mongo
output=$(./mongod --fork $@ &)
wait $!
pid=$(echo $output | grep forked | sed -E 's/.*: ([0-9]+)/\1/g')
echo PID: $pid
./mongo --eval "load('../../dev/scripts/mongo/makeadmin.js')"
kill $pid &> /dev/null
