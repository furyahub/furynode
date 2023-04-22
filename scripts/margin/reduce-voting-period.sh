#!/usr/bin/env bash

set -x

echo "$(jq '.app_state.gov.voting_params.voting_period = "60s"' $HOME/.furynd/config/genesis.json)" > $HOME/.furynd/config/genesis.json