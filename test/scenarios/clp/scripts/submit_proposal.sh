#!/bin/sh

# submit proposal to update clp params
furynd tx gov submit-proposal param-change ./scripts/proposal.json \
--from fury --keyring-backend test \
--fees 100000fury \
--chain-id localnet \
--broadcast-mode block \
-y