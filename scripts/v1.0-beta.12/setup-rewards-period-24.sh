#!/usr/bin/env bash

furynoded tx clp reward-period --path=./data/rp_24.json \
	--from $ADMIN_KEY \
	--gas=500000 \
	--gas-prices=0.5fury \
	--chain-id $FURYCHAIN_ID \
	--node $FURYNODE \
	--broadcast-mode block \
	--yes