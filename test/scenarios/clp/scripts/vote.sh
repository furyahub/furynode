#!/bin/sh

# Vote yes to accept the proposal
furynd tx gov vote 1 yes \
--from fury --keyring-backend test \
--fees 100000fury \
--chain-id  localnet \
--broadcast-mode block \
-y