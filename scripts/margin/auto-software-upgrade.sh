#!/usr/bin/env bash

set -x

furynd tx gov submit-proposal software-upgrade "${NEW_VERSION}" \
  --from ${FURY_ACT} \
  --deposit "${DEPOSIT}" \
  --upgrade-height "${TARGET_BLOCK}" \
  --upgrade-info "{\"binaries\":{\"linux/amd64\":\"https://github.com/Furynet/furynode/releases/download/v${NEW_VERSION}/furynd-v${NEW_VERSION}-linux-amd64.zip?checksum=${CHECKSUM}\"}}" \
  --title "v${NEW_VERSION}" \
  --description "v${NEW_VERSION}" \
  --chain-id "${FURYNODE_CHAIN_ID}" \
  --node "${FURYNODE_NODE}" \
  --keyring-backend "test" \
  --fees 100000000000000000fury \
  --broadcast-mode=block \
  -y