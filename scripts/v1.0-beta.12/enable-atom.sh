#!/usr/bin/env bash

furynd tx tokenregistry register ./data/atom_all_permissions.json \
	--from $ADMIN_KEY \
	--gas=500000 \
	--gas-prices=0.5fury \
	--chain-id $FURYCHAIN_ID \
	--node $FURYNODE \
	--broadcast-mode block \
	--yes