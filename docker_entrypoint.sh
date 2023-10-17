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
    --bootnodes "enode://6f7354f6dbb692c6995b4cc1df9d7d9ac334d0d94e53f7b1dcfe0d81a57fc869e896778e9b702c30dbe6446708be9fbdf29b715fb6a6a44c973c8f5b3df7f60c@alice:30311" \
    > /app/bsc-node.log 2>&1 &

sleep 4

exec tail -f /app/bsc-node.log
