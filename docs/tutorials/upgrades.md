1. Initialize the chain

```
make init
```

2. Decrease the governance voting period time before first start;


```bash
echo "$(jq '.app_state.gov.voting_params.voting_period = "60s"' $HOME/.furynoded/config/genesis.json)" > $HOME/.furynoded/config/genesis.json
```

3. Start the chain:

```
make run
```

4. List upgrade proposals:

```
furynoded q gov proposals --chain-id localnet
```

5. Raise an upgrade proposal:


```bash
furynoded tx gov submit-proposal software-upgrade plan_name \
  --from fury \
  --deposit 10000000000000000000stake \
  --upgrade-height 30 \
  --upgrade-info '{"binaries":{"linux/amd64":"url_with_checksum"}}' \
  --title test_release \
  --description "Test Release" \
  --keyring-backend test \
  --chain-id localnet \
  --broadcast-mode block \
  --fees 100000000000000000fury \
  -y
```

6. Check deposits:

```
furynoded q gov deposits 1
```

7. Vote on proposal:

```
furynoded tx gov vote 1 yes --from fury --chain-id localnet --keyring-backend test -y --broadcast-mode block
```

The node will have a consensus failure when it reaches the "upgrade-height". Restarting the node will not be enough for the chain to continue a new furynoded release is required

8. Make a new furynoded release:

  i. Update "version" file content to "plan_name"
  ii. Update "app/setup_handlers.go" "releaseVersion" constant to "plan_name"

6. Run the new release:

```
make run
```
