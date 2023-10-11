#!/usr/bin/env bash
basedir=$(cd `dirname $0`; pwd)
workspace=${basedir}
source ${workspace}/.env
keys_dir_name="keys"
authorities=("alice" "bob" "charlie" "dave" "eve") # predefined authorities

rm -f ${workspace}/bsc-genesis-contract/validators.conf

for ((i=0;i<${#authorities[@]};i++));do
    cd ${workspace}/${keys_dir_name}/${authorities[i]}
    cons_addr="0x$(cat consensus/keystore/* | jq -r .address)"
    fee_addr="0x$(cat fee/keystore/* | jq -r .address)"
    vote_addr=0x$(cat bls/keystore/*json| jq .pubkey | sed 's/"//g')
    cd ${workspace}
    bbcfee_addrs=${fee_addr}
    powers="0x000001d1a94a2000"
    echo "${cons_addr},${bbcfee_addrs},${fee_addr},${powers},${vote_addr}" >> ${workspace}/bsc-genesis-contract/validators.conf
    echo "validator" ${i} ":" ${cons_addr}
    echo "validatorFee" ${i} ":" ${fee_addr}
    echo "validatorVote" ${i} ":" ${vote_addr}
done

cd ${workspace}/bsc-genesis-contract/
node generate-validator.js
node generate-initHolders.js --initHolders ${INIT_HOLDER}
node generate-genesis.js --chainid ${BSC_CHAIN_ID} --network 'local' --whitelist1Address ${INIT_HOLDER}