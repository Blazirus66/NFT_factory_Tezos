#import "./nft_errors.mligo"
#import "./nft_parameters.mligo"
#import "./nft_storage.mligo"

let add_admin (new_admin : address) (store : storage) : storage =
    let () = match (Tezos.get_sender() = store.admin) with 
        | true -> ()
        | false -> failwith(nft_errors.not_admin)
    in
    { store with pending_admins = new_admin :: store.pending_admins }

let remove_admin (admin_to_remove : address) (store : storage) : storage =
    let () = match (Tezos.get_sender() = store.admin) with 
        | true -> ()
        | false -> failwith(nft_errors.not_admin)
    in
    let updated_admins = List.filter (fun admin -> admin <> admin_to_remove) store.pending_admins in
    { store with pending_admins = updated_admins }

let accept_admin_role (store : storage) : storage =
    let () = match (List.mem Tezos.get_sender() store.pending_admins) with
        | true -> ()
        | false -> failwith(nft_errors.not_pending_admin)
    in
    { store with admin = Tezos.get_sender(); pending_admins = List.filter (fun admin -> admin <> Tezos.get_sender()) store.pending_admins }

let ban_user (user_to_ban : address) (store : storage) : storage =
    let () = match (Tezos.get_sender() = store.admin) with 
        | true -> ()
        | false -> failwith(nft_errors.not_admin)
    in
    { store with banned_users = user_to_ban :: store.banned_users }

let unban_user (user_to_unban : address) (store : storage) : storage =
    let () = match (Tezos.get_sender() = store.admin) with 
        | true -> ()
        | false -> failwith(nft_errors.not_admin)
    in
    let updated_banned_users = List.filter (fun user -> user <> user_to_unban) store.banned_users in
    { store with banned_users = updated_banned_users }

let whitelist_self (store : storage) : storage =
    let () = match (Tezos.amount >= 10_000_000) with
        | true -> ()
        | false -> failwith(nft_errors.insufficient_funds)
    in
    { store with whitelisted_creators = Tezos.get_sender() :: store.whitelisted_creators }

let create_collection (new_nft : nft) (store : storage) : storage =
    let () = match (List.mem Tezos.get_sender() store.whitelisted_creators) && not (List.mem Tezos.get_sender() store.banned_users) with
        | true -> ()
        | false -> failwith("User not whitelisted or is banned")
    in
    let updated_collections = Map.add Tezos.get_sender() [new_nft] store.collections in
    { store with collections = updated_collections }

let main (action : parameter)(store : storage) : return =
    ([] : operation list), (match action with
        | AddAdmin (addr) -> add_admin addr store
        | RemoveAdmin (addr) -> remove_admin addr store
        | AcceptAdminRole -> accept_admin_role store
        | BanUser (addr) -> ban_user addr store
        | UnbanUser (addr) -> unban_user addr store
        | WhitelistSelf -> whitelist_self store
        | CreateCollection (nft) -> create_collection nft store)
