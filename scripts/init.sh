#!/usr/bin/env bash

### chain init script for development purposes only ###

make clean install
rm -rf ~/.furynoded
furynoded init test --chain-id=localnet -o

echo "Generating deterministic account - fury"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | furynoded keys add fury --recover --keyring-backend=test

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | furynoded keys add akasha --recover --keyring-backend=test

echo "Generating deterministic account - alice"
echo "crunch enable gauge equip sadness venture volcano capable boil pole lounge because service level giggle decide south deposit bike antique consider olympic girl butter" | furynoded keys add alice --recover --keyring-backend=test

furynoded keys add mkey --multisig fury,akasha --multisig-threshold 2 --keyring-backend=test

furynoded add-genesis-account $(furynoded keys show fury -a --keyring-backend=test) 500000000000000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink,5000000000000cusdt,90000000000000000000ibc/96D7172B711F7F925DFC7579C6CCC3C80B762187215ABD082CDE99F81153DC80 --keyring-backend=test
furynoded add-genesis-account $(furynoded keys show akasha -a --keyring-backend=test) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test
furynoded add-genesis-account $(furynoded keys show alice -a --keyring-backend=test) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test

furynoded add-genesis-clp-admin $(furynoded keys show fury -a --keyring-backend=test) --keyring-backend=test
furynoded add-genesis-clp-admin $(furynoded keys show akasha -a --keyring-backend=test) --keyring-backend=test

furynoded set-genesis-oracle-admin fury --keyring-backend=test
furynoded add-genesis-validators $(furynoded keys show fury -a --bech val --keyring-backend=test) --keyring-backend=test

furynoded set-genesis-whitelister-admin fury --keyring-backend=test
furynoded set-gen-denom-whitelist scripts/denoms.json

furynoded gentx fury 1000000000000000000000000stake --moniker fury_val --chain-id=localnet --keyring-backend=test

echo "Collecting genesis txs..."
furynoded collect-gentxs

echo "Validating genesis file..."
furynoded validate-genesis
