import { InMemorySigner } from "@taquito/signer";
import { TezosToolkit, MichelsonMap } from "@taquito/taquito";

import * as dotenv from 'dotenv';
import code from "../compiled/main.json";

dotenv.config(( { path: '../.env' } ));

const TezosNodeRPC : string = process.env.TEZOS_NODE_URL;
const publicKey : string = process.env.ADMIN_PUBLIC_KEY;
const privateKey : string = process.env.ADMIN_PRIVATE_KEY;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider({ signer: signature });

Tezos.tz.getBalance(publicKey)
    .then((balance) => console.log(`Address Balance : ${balance.toNumber() / 1000000} ꜩ`))
    .catch((error) => console.log(JSON.stringify(error)));

const deploy = async () => {
    try {
        const storage = {
            admin : publicKey,
            winner : null,
            numbers : new MichelsonMap(),
        }
        const origination = await Tezos.contract.originate({
            code : code,
            storage: storage
        });
        console.log(origination.contractAddress);
    }
    catch (error) {
        console.log(error)
    }


}

deploy()