#!/bin/zsh

sed -i -s 's/        "voting_period": "172800s"/        "voting_period": "60s"/g' ~/.furynode-1/config/genesis.json
sed -i -s 's/        "voting_period": "172800s"/        "voting_period": "60s"/g' ~/.furynode-2/config/genesis.json
sed -i -s 's/        "voting_period": "172800s"/        "voting_period": "60s"/g' ~/.furynode-3/config/genesis.json
