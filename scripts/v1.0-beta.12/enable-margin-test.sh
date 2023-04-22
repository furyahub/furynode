#!/usr/bin/env bash

furynd tx margin update-pools ./data/temp_pools.json \
	--closed-pools ./data/closed_pools.json \
  --from=$ADMIN_KEY \
	--gas=500000 \
	--gas-prices=0.5fury \
	--chain-id $FURYCHAIN_ID \
	--node $FURYNODE \
	--broadcast-mode block \
	--yes

furynd tx margin whitelist fury1mwmrarhynjuau437d07p42803rntfxqjun3pfu \
  --from=$ADMIN_KEY \
	--gas=500000 \
	--gas-prices=0.5fury \
	--chain-id $FURYCHAIN_ID \
	--node $FURYNODE \
	--broadcast-mode block \
	--yes