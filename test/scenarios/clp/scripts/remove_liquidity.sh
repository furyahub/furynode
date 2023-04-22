#!/bin/sh

# Remove liquidity 
furynd tx clp remove-liquidity \
--from fury --keyring-backend test \
--fees 100000000000000000fury \
--symbol ceth \
--wBasis 5000 --asymmetry 0 \
--chain-id localnet \
--broadcast-mode block \
-y