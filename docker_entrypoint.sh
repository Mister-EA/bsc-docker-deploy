#!/bin/bash
set -e

# copy keys
cp /data/keys/password.txt /app
cp -R /data/keys/${AUTHORITY_NAME}/bls /app
cp -R /data/keys/${AUTHORITY_NAME}/consensus/keystore /app
cp -R /data/keys/${AUTHORITY_NAME}/nodekey /app/geth


CONS_ADDR="0x$(cat keystore/* | jq -r .address)"

/app/bin/geth --config /app/config.toml \
    --datadir /app \
    --password /app/password.txt \
    --blspassword /app/password.txt \
    --nodekey /app/geth/nodekey \
    -unlock ${CONS_ADDR} --rpc.allow-unprotected-txs --allow-insecure-unlock  \
    --miner.etherbase ${CONS_ADDR} \
    --ws.addr 0.0.0.0 --ws.port 8545 --http.addr 0.0.0.0 --http.port 8545 --http.corsdomain "*" \
    --metrics --metrics.addr localhost --metrics.port 6060 --metrics.expensive \
    --gcmode archive --syncmode=full --mine --vote --monitor.maliciousvote \
    --port 30311 \
    --bootnodes "enode://dfd215eac0f0bd38a6313b7a6c4d50ae0bec815ecb76f71dc1469e4f5d0970605b8db5834e7f2ac49912b825ea6985340c7e445d4fcbb8c250a4645a4a6fcbe7@alice:30311" \
    > /app/bsc-node.log 2>&1 &

sleep 4

exec tail -f /app/bsc-node.log
