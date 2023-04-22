#!/usr/bin/env bash

# Use furynoded q account $(furynoded keys show fury -a) to get seq
seq=1
furynoded tx dispensation create Airdrop output.json --gas 90128 --from $(furynoded keys show fury -a) --yes --broadcast-mode async --sequence $seq --account-number 3 --chain-id localnet
seq=$((seq+1))
furynoded tx dispensation create ValidatorSubsidy output.json --gas 90128 --from $(furynoded keys show fury -a) --yes --broadcast-mode async --sequence $seq --account-number 3 --chain-id localnet
seq=$((seq+1))
furynoded tx dispensation create ValidatorSubsidy output.json --gas 90128 --from $(furynoded keys show fury -a) --yes --broadcast-mode async --sequence $seq --account-number 3 --chain-id localnet