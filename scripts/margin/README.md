# Running Margin manual tests against localnet

From the root of the repo run the following commands:

```
rm -rf ~/furynoded
make install
./scripts/init_w_prod_tokens.sh
```

Change the working directory to `./scripts/margin` by doing:

```
cd ./scripts/margin
```

Decrease the governance voting period time by doing:

```bash
./reduce-voting-period.sh
```

Change Margin default parameters by doing:

```bash
./set-margin-params.sh
```

Then we are ready to run the local chain by doing:

```bash
../run.sh
```

Now set the following variables:

```
# localnet
export ADMIN_ADDRESS="fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd"
export ADMIN_MNEMONIC="race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow"
export FURY_ACT=fury
export FURYNODE_CHAIN_ID=localnet
export FURYNODE_P2P_HOSTNAME=localhost
export FURYNODE_NODE=tcp://${FURYNODE_P2P_HOSTNAME}:26657
```

and register the tokens and create 6 pools against those tokens by calling:

```
./register-all.sh && ./create-pools.sh
```

now calling the following commands should display all the available pools in localnet:

```
./pools.sh
```

# Test localnet using Furygen

Setup the node with `furygen`

```
furygen node create furynet-1 furynode1 "connect rocket hat athlete kind fall auction measure wage father bridge tackle midnight athlete benefit faculty shove okay win entire reveal kit era truly" \
--admin-clp-addresses="fury1mxv2xmhm9r25cdxpwp4n43fd98t8xz97mg6xyt|fury1rkl3p87fanf8srn44lp9xrxx8smtux4mfjhwf2" \
--admin-oracle-address=fury1mxv2xmhm9r25cdxpwp4n43fd98t8xz97mg6xyt \
--standalone --with-cosmovisor
```

Setup cosmovisor:

```
export DAEMON_NAME=furynoded
export DAEMON_HOME=$HOME/.furynoded
export DAEMON_ALLOW_DOWNLOAD_BINARIES=true
export DAEMON_RESTART_AFTER_UPGRADE=true
export UNSAFE_SKIP_BACKUP=true
```

Start the localnet chain:

```
cosmovisor start --rpc.laddr tcp://0.0.0.0:26657
```
