#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "../../contracts/nft_factory/nft_errors.mligo" "NFT_Errors"

let () = Test.log("[NFT FACTORY] Testing entrypoints for NFT Factory contract")

(* Test for a successful addition of an administrator *)
let test_success_add_administrator = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let _ = Test.transfer_to_contract contr (AddAdministrator(user1)) 0mutez in
    ()

(* Test for a failure when a non-admin tries to add another admin *)
let test_failure_add_administrator_non_admin = 
    let (admin, user1, user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user2 in
    let test_result : test_exec_result = Test.transfer_to_contract contr (AddAdministrator(user1)) 0mutez in
    let () = match  test_result with
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval NFT_Errors.only_admin))
        | Fail (Balance_too_low _) -> failwith ("Balance is too low")
        | Fail (Other p) -> failwith (p)
        | Success (_) -> failwith("Test should have failed")
    in
    ()

