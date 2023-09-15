import { InMemorySigner } from "@taquito/signer";
import { TezosToolkit, MichelsonMap } from "@taquito/taquito";
import * as dotenv from 'dotenv';
import code from "../compiled/nft_main.json";

dotenv.config({ path: '../.env' });

const TezosNodeRPC: string = process.env.TEZOS_NODE_URL!;
const publicKey: string = process.env.ADMIN_PUBLIC_KEY!;
const privateKey: string = process.env.ADMIN_PRIVATE_KEY!;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider({ signer: signature });

const deploy = async () => {
    try {
        const storage = {
            admin: publicKey,
            pending_admins: [],
            banned_users: [],
            whitelisted_creators: [],
            collections: new MichelsonMap()
        };

        const origination = await Tezos.contract.originate({
            code: code,
            storage: storage
        });

        console.log(`Contract deployed at address: ${origination.contractAddress}`);
    } catch (error) {
        console.error(`Error deploying contract: ${error}`);
    }
}

deploy();
