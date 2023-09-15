#import "../../../contracts/nft_factory/nft_main.mligo" "NFT_Contract"

type originated = {
    addr : address;
    t_addr : (NFT_Contract.parameter, NFT_Contract.storage) typed_address;
    contr : NFT_Contract.parameter contract
}

let bootstrap_accounts () =
    let () = Test.reset_state 5n ([] : tez list) in
    let accounts =
        Test.nth_bootstrap_account 1,
        Test.nth_bootstrap_account 2,
        Test.nth_bootstrap_account 3
    in
    accounts

let initial_storage(initial_admin : address) = {
    admin = initial_admin;
    pending_admins = [];
    banned_users = [];
    whitelisted_creators = [];
    collections = (Map.empty : NFT_Contract.collections);
}

let initial_balance = 0mutez

let originate_contract (admin : address) =
    let (typed_address, _code, _nonce) = Test.originate NFT_Contract.main (initial_storage(admin)) initial_balance in
    let actual_storage = Test.get_storage typed_address in
    let () = assert((initial_storage(admin)) = actual_storage) in
    let contr = Test.to_contract typed_address in
    let addr = Tezos.address contr in
    (addr, typed_address, contr)
