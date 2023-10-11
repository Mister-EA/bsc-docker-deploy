#!/bin/bash
set -e


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
    --bootnodes "enode://dfd215eac0f0bd38a6313b7a6c4d50ae0bec815ecb76f71dc1469e4f5d0970605b8db5834e7f2ac49912b825ea6985340c7e445d4fcbb8c250a4645a4a6fcbe7@alice:30311,enode://68672f4aeec6132d8a208b09857bb02effbc328d3907d944dd1c4e46617b13fb10072b909bcda0b42a4f9f8b3c933f7b4f066910e0544437f8c37a84cef72639@bob:30311,enode://b22ef77f0c32a7e5c3a05e3f2e39be989315cf9825a13fb537560d6b08da75b5ab4c56bac58fccd1ab0f5967350dfffbcf1bee9b7c4eca827477bcf19795cac3@charlie:30311" \
    > /app/bsc-node.log 2>&1 &

sleep 4

exec tail -f /app/bsc-node.log
