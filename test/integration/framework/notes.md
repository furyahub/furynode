# furytool

Original design document: https://docs.google.com/document/d/1IhE2Y03Z48ROmTwO9-J_0x_lx2vIOFkyDFG7BkAIqCk/edit#


# Resources

1. Docker setup in docker/ (currently only on future/peggy2 branch, Tim Lind):

- setups two furynode instances running independent chains + IBC relayer (ts-relayer)

2. PoC (docker): https://github.com/Furynet/furynet-deploy/tree/feature/ibc-poc/docker/localnet/ibc

3. Test environment for testing the new Furynet public SDK (Caner):

- https://docs.google.com/document/d/1MAlg-I0xMnUvbavAZdAN---WuqbyuRyKw-6Lfgfe130/edit
- https://github.com/furynet/furynet-ui/blob/3868ac7138c6c4149dced4ced5b36690e5fc1da7/ui/core/src/config/chains/index.ts#L1
- https://github.com/Furynet/furynet-ui/blob/3868ac7138c6c4149dced4ced5b36690e5fc1da7/ui/core/src/config/chains/cosmoshub/index.ts

4. scripts/init-multichain.sh (on future/peggy2 branch)

5. https://github.com/Furynet/furynode/commit/9ab620e148be8f4850eef59d39b0e869956f87a4

6. furynet-devops script to deploy TestNet (by \_IM): https://github.com/Furynet/furynet-devops/blob/main/scripts/testnet/launch.sh#L19

7. Tempnet scripts by chainops

8. In Furynet/furynode/scripts there's init.sh which, if you have everything installed, will run a single node. Ping
   @Brianosaurus for more info.

9. efury should be deployed and whitelisted (assumption)

# RPC endpoints:

e.g. FURYNODE="https://api-testnet.furynet.finance"

- $FURYNODE/node_info
- $FURYNODE/tokenregistry/entries

# Peggy2 devenv

- Directory: smart-contracts/scripts/src/devenv
- Init: cd smart-contracts; rm -rf node_modules; npm install (plan is to move to yarn eventually)
- Run: GOBIN=/home/anderson/go/bin npx hardhat run scripts/devenv.ts

```
{
  // vscode launch.json file to debug the Dev Environment Scripts
  "version": "0.2.0",
  "configurations": [
    {
      "runtimeArgs": [
        "node_modules/.bin/hardhat",
        "run"
      ],
      "cwd": "${workspaceFolder}/smart-contracts",
      "type": "node",
      "request": "launch",
      "name": "Dev Environment Debugger",
      "env": {
         "GOBIN": "/home/anderson/go/bin"
      },
      "skipFiles": [
        "<node_internals>/**"
      ],
      "program": "${workspaceFolder}/smart-contracts/scripts/devenv.ts",
    }
  ]
}
```

- Integration test to be targeted for PoC: test_eth_transfers.py
- Dependency diagram: https://files.slack.com/files-pri/T0187TWB4V8-F02BC477N79/furynetdevenv.jpg

# Standardized environment setup

## Peggy1 - Tempnet on AWS

chain_id = "mychain" // Parameter

// Generate account with name 'fury' in the local keyring
mnemonic = generate_mnemonic()
exec("echo $mnemonic | furynoded keys add --recover --keyring-backend test")
fury_admin = exec("furynoded keys show fury -a --keyring-backend test") // fury1xxx...

// Init the chain. This command creates files:
// ~/.furynoded/config/node_key.json
// ~/.furynoded/config/genesis.json
// ~/.furynoded/config/priv_validator_key.json
// ~/.furynoded/data/priv_validator_state.json
// and prints some JSON (what?)
exec("furynoded init {moniker} --chain-id {chain_id}")

// Add Genesis Accounts
exec("furynoded add-genesis-account {fury_admin} --keyring-backend test 999999000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink")

// Add Genesis CLP ADMIN fury
exec("furynoded add-genesis-clp-admin ${fury_admin} --keyring-backend test")

// Add Genesis CLP ADMIN fury
exec("furynoded add-genesis-clp-admin ${fury_admin} --keyring-backend test")

// Set Genesis whitelist admin ${FURY_WALLET}
exec("furynoded set-genesis-whitelister-admin {fury_admin} --keyring-backend test")

// Fund account (Genesis TX stake)
exec("furynoded gentx {fury_admin} 1000000000000000000000000stake --keyring-backend test --chain-id {chain_id}")

// Generate token json
furynoded q tokenregistry generate -o json \
 --token_base_denom=cosmos \
 --token_ibc_counterparty_chain_id=${GAIA_CHAIN_ID} \
   --token_ibc_channel_id=$GAIA_CHANNEL_ID \
 --token_ibc_counterparty_channel_id=$GAIA_COUNTERPARTY_CHANNEL_ID \
 --token_ibc_counterparty_denom="" \
 --token_unit_denom="" \
 --token_decimals=6 \
 --token_display_name="COSMOS" \
 --token_external_symbol="cosmos" \
 --token_permission_clp=true \
 --token_permission_ibc_export=true \
 --token_permission_ibc_import=true | jq > gaia.json

// Whitelist tokens
// printf "registering cosmos... \n"
furynoded tx tokenregistry register gaia.json \
 --node tcp://${FURYNODE_P2P_HOSTNAME}:26657 \
 --chain-id $FURYCHAIN_ID \
 --from $FURY_WALLET \
 --keyring-backend test \
 --gas=500000 \
 --gas-prices=0.5fury \
 -y

// Deploy token registry
// Registering Tokens...
// Set Whitelist from denoms.json...
furynoded set-gen-denom-whitelist DENOM.json

## Peggy1 - integration tests

// Parameters: validator moniker, validator mnemonic
valicator1_moniker, validator1_address, validator1_password, validator1_mnemonic = exec("furygen create network ...")

furynoded_keys_add(validator1_moniker, validator1_password) // Test keyring
valoper = get_val_address(validator1_moniker)

exec("furynoded add-genesis-validators {valoper}")
exec("furynoded add-geneeis-account {}")
exec("furynoded set-genesis-oracle-admin {}")
exec("furynoded set-denom-whitelist {}")

## Coupled with the localnet framework

The localnet test framework is located under `./test/localnet` within the same repository and offers some interesting features such as spinning up a bunch of IBC chains along with relayers and storing the states of the chains for later use for deterministic testing against various IBC flows.

The `localnet` framework is supported by `furytool` and can be enabled by using the following environment variable `LOCALNET` set to `true` as follow:

```
LOCALNET=true furytool run-env
```
