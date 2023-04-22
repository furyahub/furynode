height=$(furynd --home $CHAINDIR/.furynd q block | jq -r .block.header.height)
seq $height | parallel -k furynd --home $CHAINDIR/.furynd q block {}
