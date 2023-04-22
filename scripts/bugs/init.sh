#!/usr/bin/env bash

### chain init script for development purposes only ###

make clean install
furynoded init test --chain-id=localnet

echo "Generating deterministic account - fury"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | furynoded keys add fury --recover

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | furynoded keys add akasha --recover

furynoded add-genesis-account $(furynoded keys show fury -a) 16205782692902021002506278400fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink,899999867990000000000000000000cacoin
furynoded add-genesis-account $(furynoded keys show akasha -a) 5000000000000003407464fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink,8999998679900000000000000000000cacoin

furynoded add-genesis-clp-admin $(furynoded keys show fury -a)
furynoded add-genesis-clp-admin $(furynoded keys show akasha -a)

furynoded  add-genesis-validators $(furynoded keys show fury -a --bech val)

furynoded gentx fury 1000000000000000000000000stake --keyring-backend test

echo "Collecting genesis txs..."
furynoded collect-gentxs

echo "Validating genesis file..."
furynoded validate-genesis
