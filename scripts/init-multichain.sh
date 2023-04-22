#!/usr/bin/env bash

if ! type "hermes" > /dev/null; then
  # install foobar here
  echo "You need the hermes relayer to run this script. You can find it here https://github.com/informalsystems/ibc-rs"
  exit 0
fi

### chain init script for development purposes only ###
killall furynoded
killall hermes
rm -rf ~/.furynode-1
rm -rf ~/.furynode-2
rm -rf ~/.furynode-3
make clean install
furynoded init test --chain-id=localnet-1 -o --home ~/.furynode-1

echo "Generating deterministic account - fury"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | furynoded keys add fury --recover --keyring-backend=test --home ~/.furynode-1

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | furynoded keys add akasha --recover --keyring-backend=test --home ~/.furynode-1


furynoded keys add mkey --multisig fury,akasha --multisig-threshold 2 --keyring-backend=test --home ~/.furynode-1

furynoded add-genesis-account $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-1) 50000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test --home ~/.furynode-1
furynoded add-genesis-account $(furynoded keys show akasha -a --keyring-backend=test --home ~/.furynode-1) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test --home ~/.furynode-1

furynoded add-genesis-clp-admin $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-1) --keyring-backend=test --home ~/.furynode-1
furynoded add-genesis-clp-admin $(furynoded keys show akasha -a --keyring-backend=test --home ~/.furynode-1 ) --keyring-backend=test --home ~/.furynode-1
furynoded set-genesis-whitelister-admin $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-1) --keyring-backend=test --home ~/.furynode-1
furynoded set-gen-denom-whitelist scripts/denoms.json --home ~/.furynode-1

furynoded add-genesis-validators $(furynoded keys show fury -a --bech val --keyring-backend=test --home ~/.furynode-1) --keyring-backend=test --home ~/.furynode-1

furynoded gentx fury 1000000000000000000000000stake --keyring-backend=test --home ~/.furynode-1 --chain-id=localnet-1

echo "Collecting genesis txs..."
furynoded collect-gentxs --home ~/.furynode-1

echo "Validating genesis file..."
furynoded validate-genesis --home ~/.furynode-1



furynoded init test --chain-id=localnet-2 -o --home ~/.furynode-2


echo "Generating deterministic account - fury"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | furynoded keys add fury --recover --keyring-backend=test --home ~/.furynode-2

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | furynoded keys add akasha --recover --keyring-backend=test --home ~/.furynode-2


furynoded keys add mkey --multisig fury,akasha --multisig-threshold 2 --keyring-backend=test --home ~/.furynode-2

furynoded add-genesis-account $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-2 ) 50000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test --home ~/.furynode-2
furynoded add-genesis-account $(furynoded keys show akasha -a --keyring-backend=test --home ~/.furynode-2) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test --home ~/.furynode-2

furynoded add-genesis-clp-admin $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-2 ) --keyring-backend=test --home ~/.furynode-2
furynoded add-genesis-clp-admin $(furynoded keys show akasha -a --keyring-backend=test --home ~/.furynode-2) --keyring-backend=test --home ~/.furynode-2
furynoded set-genesis-whitelister-admin $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-2) --keyring-backend=test --home ~/.furynode-2
furynoded set-gen-denom-whitelist scripts/denoms.json --home ~/.furynode-2
furynoded add-genesis-validators $(furynoded keys show fury -a --bech val --keyring-backend=test --home ~/.furynode-2 ) --keyring-backend=test --home ~/.furynode-2

furynoded gentx fury 1000000000000000000000000stake --chain-id=localnet --keyring-backend=test --home ~/.furynode-2 --chain-id=localnet-2


echo "Collecting genesis txs..."
furynoded collect-gentxs --home ~/.furynode-2

echo "Validating genesis file..."
furynoded validate-genesis --home ~/.furynode-2



furynoded init test --chain-id=localnet-3 -o --home ~/.furynode-3


echo "Generating deterministic account - fury"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | furynoded keys add fury --recover --keyring-backend=test --home ~/.furynode-3

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | furynoded keys add akasha --recover --keyring-backend=test --home ~/.furynode-3


furynoded keys add mkey --multisig fury,akasha --multisig-threshold 2 --keyring-backend=test --home ~/.furynode-3

furynoded add-genesis-account $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-3 ) 50000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test --home ~/.furynode-3
furynoded add-genesis-account $(furynoded keys show akasha -a --keyring-backend=test --home ~/.furynode-3) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test --home ~/.furynode-3

furynoded add-genesis-clp-admin $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-3 ) --keyring-backend=test --home ~/.furynode-3
furynoded add-genesis-clp-admin $(furynoded keys show akasha -a --keyring-backend=test --home ~/.furynode-3) --keyring-backend=test --home ~/.furynode-3
furynoded set-genesis-whitelister-admin $(furynoded keys show fury -a --keyring-backend=test --home ~/.furynode-3) --keyring-backend=test --home ~/.furynode-3
furynoded set-gen-denom-whitelist scripts/denoms.json --home ~/.furynode-3
furynoded add-genesis-validators $(furynoded keys show fury -a --bech val --keyring-backend=test --home ~/.furynode-3 ) --keyring-backend=test --home ~/.furynode-3

furynoded gentx fury 1000000000000000000000000stake --chain-id=localnet-3 --keyring-backend=test --home ~/.furynode-3 --chain-id=localnet-3

echo "Collecting genesis txs..."
furynoded collect-gentxs --home ~/.furynode-3

echo "Validating genesis file..."
furynoded validate-genesis --home ~/.furynode-3

rm -rf abci_*.log
rm -rf hermes.log
rm -rf ~/.hermes

echo "Chainging voting period to 60 seconds"
sed -i -s 's/        "voting_period": "172800s"/        "voting_period": "60s"/g' ~/.furynode-1/config/genesis.json
sed -i -s 's/        "voting_period": "172800s"/        "voting_period": "60s"/g' ~/.furynode-2/config/genesis.json
sed -i -s 's/        "voting_period": "172800s"/        "voting_period": "60s"/g' ~/.furynode-3/config/genesis.json

echo "Starting furynoded's"

sleep 1
furynoded start --home ~/.furynode-1 --p2p.laddr 0.0.0.0:27655  --grpc.address 0.0.0.0:9090 --grpc-web.address 0.0.0.0:9093 --address tcp://0.0.0.0:27659 --rpc.laddr tcp://127.0.0.1:27665 >> abci_1.log 2>&1  &
sleep 1
furynoded start --home ~/.furynode-2 --p2p.laddr 0.0.0.0:27656  --grpc.address 0.0.0.0:9091 --grpc-web.address 0.0.0.0:9094 --address tcp://0.0.0.0:27660 --rpc.laddr tcp://127.0.0.1:27666 >> abci_2.log 2>&1  &
sleep 1
furynoded start --home ~/.furynode-3 --p2p.laddr 0.0.0.0:27657  --grpc.address 0.0.0.0:9092 --grpc-web.address 0.0.0.0:9095 --address tcp://0.0.0.0:27661 --rpc.laddr tcp://127.0.0.1:27667 >> abci_3.log 2>&1 &
sleep 10

echo "updating token registries with IBC paths"
echo "doing localnet-1"
furynoded tx tokenregistry register scripts/fury-localnet-1-localnet-2.json --node tcp://127.0.0.1:27665 --keyring-backend test --chain-id localnet-1 --from fury --gas 200000 --gas-prices 0.5fury --home ~/.furynode-1 --yes
sleep 10
furynoded tx tokenregistry register scripts/fury-localnet-1-localnet-3.json --node tcp://127.0.0.1:27665 --keyring-backend test --chain-id localnet-1 --from fury --gas 200000 --gas-prices 0.5fury --home ~/.furynode-1 --yes
echo ""
sleep 10

echo "Doing localnet-2"
furynoded tx tokenregistry register scripts/fury-localnet-2-localnet-1.json --node tcp://127.0.0.1:27666 --keyring-backend test --chain-id localnet-2 --from fury --gas 200000 --gas-prices 0.5fury --home ~/.furynode-2 --yes
sleep 10
furynoded tx tokenregistry register scripts/fury-localnet-2-localnet-3.json --node tcp://127.0.0.1:27666 --keyring-backend test --chain-id localnet-2 --from fury --gas 200000 --gas-prices 0.5fury --home ~/.furynode-2 --yes
echo ""
sleep 10

echo "Doing localnet-3"
furynoded tx tokenregistry register scripts/fury-localnet-3-localnet-1.json --node tcp://127.0.0.1:27667 --keyring-backend test --chain-id localnet-3 --from fury --gas 200000 --gas-prices 0.5fury --home ~/.furynode-3 --yes
sleep 10
furynoded tx tokenregistry register scripts/fury-localnet-3-localnet-2.json --node tcp://127.0.0.1:27667 --keyring-backend test --chain-id localnet-3 --from fury --gas 200000 --gas-prices 0.5fury --home ~/.furynode-3 --yes
echo ""

sleep 10

echo "Setting hermes"
# copy hermes config to the hermes directory
mkdir ~/.hermes
cp scripts/hermes_config.toml ~/.hermes/config.toml

hermes keys restore -m "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" localnet-1 --name fury
hermes keys restore -m "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" localnet-2 --name fury
hermes keys restore -m "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" localnet-3 --name fury

# create hermes channels
echo "Creating localnet-1 to localnet-2"
hermes create channel localnet-1 localnet-2 --port-a transfer --port-b transfer -o unordered
sleep 1
echo "Creating localnet-2 to localnet-3"
hermes create channel localnet-2 localnet-3 --port-a transfer --port-b transfer -o unordered
sleep 1
echo "Creating localnet-1 to localnet-3"
hermes create channel localnet-1 localnet-3 --port-a transfer --port-b transfer -o unordered
sleep 1

# start hermes
hermes start > hermes.log 2>&1 &

echo "Sleeping to let hermes boot"
sleep 10
