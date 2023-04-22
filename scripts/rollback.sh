#!/usr/bin/env bash

pkill furynoded
sleep 5
furynoded export --height -1 > exported_state.json
sleep 1
furynoded migrate v0.38 exported_state.json --chain-id new-chain > new-genesis.json  2>&1
sleep 1
furynoded unsafe-reset-all
sleep 1
cp new-genesis.json ~/.furynoded/config/genesis.json
sleep 2
furynoded start