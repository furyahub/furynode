#!/usr/bin/env bash
rm -rf ~/.furynd
rm -rf ~/.furynd
rm -rf furynode.log
rm -rf testlog.log


furynd init test --chain-id=furynet -o

echo "Generating deterministic account - fury"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | furynd keys add fury --recover

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | furynd keys add akasha --recover

furynd add-genesis-account $(furynd keys show fury -a) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink
furynd add-genesis-account $(furynd keys show akasha -a) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink

furynd add-genesis-clp-admin $(furynd keys show fury -a)
furynd add-genesis-clp-admin $(furynd keys show akasha -a)

furynd  add-genesis-validators $(furynd keys show fury -a --bech val)

furynd gentx fury 1000000000000000000000000stake --keyring-backend test

echo "Collecting genesis txs..."
furynd collect-gentxs

echo "Validating genesis file..."
furynd validate-genesis




#contents="$(jq '.gov.voting_params.voting_period = 10' $DAEMON_HOME/config/genesis.json)" && \
#echo "${contents}" > $DAEMON_HOME/config/genesis.json
