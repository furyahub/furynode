#!/usr/bin/env bash

. ../credentials.sh

rm -rf ~/.furynoded

furynoded init test --chain-id=furynet-local
cp ./app.toml ~/.furynoded/config

echo "Generating deterministic account - ${SHADOWFIEND_NAME}"
echo "${SHADOWFIEND_MNEMONIC}" | furynoded keys add ${SHADOWFIEND_NAME}  --keyring-backend=test --recover

echo "Generating deterministic account - ${AKASHA_NAME}"
echo "${AKASHA_MNEMONIC}" | furynoded keys add ${AKASHA_NAME}  --keyring-backend=test --recover

echo "Generating deterministic account - ${JUNIPER_NAME}"
echo "${JUNIPER_MNEMONIC}" | furynoded keys add ${JUNIPER_NAME} --keyring-backend=test --recover

furynoded add-genesis-account $(furynoded keys show ${SHADOWFIEND_NAME} -a --keyring-backend=test) 100000000000000000000000000000fury,100000000000000000000000000000catk,100000000000000000000000000000cbtk,100000000000000000000000000000ceth,100000000000000000000000000000cusdc,100000000000000000000000000000clink,100000000000000000000000000stake
furynoded add-genesis-account $(furynoded keys show ${AKASHA_NAME} -a --keyring-backend=test) 100000000000000000000000000000fury,100000000000000000000000000000catk,100000000000000000000000000000cbtk,100000000000000000000000000000ceth,100000000000000000000000000000cusdc,100000000000000000000000000000clink,100000000000000000000000000stake
furynoded add-genesis-account $(furynoded keys show ${JUNIPER_NAME} -a --keyring-backend=test) 10000000000000000000000fury,10000000000000000000000cusdc,100000000000000000000clink,100000000000000000000ceth

furynoded add-genesis-validators $(furynoded keys show ${SHADOWFIEND_NAME} -a --bech val --keyring-backend=test)

furynoded gentx ${SHADOWFIEND_NAME} 1000000000000000000000000stake --chain-id=furynet-local --keyring-backend test

echo "Collecting genesis txs..."
furynoded collect-gentxs

echo "Validating genesis file..."
furynoded validate-genesis

echo "Starting test chain"

./start.sh
