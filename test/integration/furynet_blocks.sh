height=$(furynoded --home $CHAINDIR/.furynoded q block | jq -r .block.header.height)
seq $height | parallel -k furynoded --home $CHAINDIR/.furynoded q block {}
