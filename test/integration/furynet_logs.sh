#!/bin/bash

basedir=$(dirname $0)
. $basedir/vagrantenv.sh

hashes=$(cat $* | grep "^txhash: " | sed -e "s/txhash: //")
for i in $hashes
do
  furynd q tx --home $CHAINDIR/.furynd $i -o json | jq -c .
done
