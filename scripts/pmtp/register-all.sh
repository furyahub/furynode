#!/usr/bin/env bash

set -x

furynoded tx tokenregistry register denoms/fury.json \
  --node ${FURYNODE_NODE} \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5fury \
  -y \
  --broadcast-mode block

furynoded tx tokenregistry register denoms/ceth.json \
  --node ${FURYNODE_NODE} \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5fury \
  -y \
  --broadcast-mode block

furynoded tx tokenregistry register denoms/cusdc.json \
  --node ${FURYNODE_NODE} \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5fury \
  -y \
  --broadcast-mode block

furynoded tx tokenregistry register denoms/cusdt.json \
  --node ${FURYNODE_NODE} \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5fury \
  -y \
  --broadcast-mode block

furynoded tx tokenregistry register denoms/uatom.json \
  --node ${FURYNODE_NODE} \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5fury \
  -y \
  --broadcast-mode block

furynoded tx tokenregistry register denoms/ujuno.json \
  --node ${FURYNODE_NODE} \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5fury \
  -y \
  --broadcast-mode block

furynoded tx tokenregistry register denoms/uluna.json \
  --node ${FURYNODE_NODE} \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5fury \
  -y \
  --broadcast-mode block