#!/usr/bin/env bash

# Use furynd q account $(furynd keys show fury -a) to get seq
seq=1
furynd tx dispensation create Airdrop output.json --gas 90128 --from $(furynd keys show fury -a) --yes --broadcast-mode async --sequence $seq --account-number 3 --chain-id localnet
seq=$((seq+1))
furynd tx dispensation create ValidatorSubsidy output.json --gas 90128 --from $(furynd keys show fury -a) --yes --broadcast-mode async --sequence $seq --account-number 3 --chain-id localnet
seq=$((seq+1))
furynd tx dispensation create ValidatorSubsidy output.json --gas 90128 --from $(furynd keys show fury -a) --yes --broadcast-mode async --sequence $seq --account-number 3 --chain-id localnet