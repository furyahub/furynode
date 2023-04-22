#!/usr/bin/env bash

furynd tx clp reward-period --path=./data/atom_rewards_fix.json \
	--from $ADMIN_KEY \
	--gas=500000 \
	--gas-prices=0.5fury \
	--chain-id $FURYCHAIN_ID \
	--node $FURYNODE \
	--broadcast-mode block \
	--yes