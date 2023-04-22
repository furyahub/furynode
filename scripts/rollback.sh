#!/usr/bin/env bash

pkill furynd
sleep 5
furynd export --height -1 > exported_state.json
sleep 1
furynd migrate v0.38 exported_state.json --chain-id new-chain > new-genesis.json  2>&1
sleep 1
furynd unsafe-reset-all
sleep 1
cp new-genesis.json ~/.furynd/config/genesis.json
sleep 2
furynd start