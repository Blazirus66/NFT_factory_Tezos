#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "../../contracts/errors.mligo" "Contract_Errors"

let () = Test.log("[MAIN] Testing entrypoints for contract")

let test_success_submitnumber = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
    ()

let test_failure_submitnumber_duplicatenumber = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
    let test_result : test_exec_result = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
    let () = match  test_result with
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval Contract_Errors.number_already_picked))
        | Fail (Balance_too_low _) -> failwith ("Balance is too low")
        | Fail (Other p) -> failwith (p)
        | Success (_) -> failwith("Test should have failed")
    in
    ()

let test_failure_submitnumber_admincannotplay =
    let (admin, _user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let test_result : test_exec_result = Test.transfer_to_contract contr (SubmitNumber(10n)) 0mutez in
    let () = match  test_result with
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval "Admin cannot submit number"))
        | Fail (Balance_too_low _) -> failwith ("Balance is too low")
        | Fail (Other p) -> failwith (p)
        | Success (_) -> failwith("Test should have failed")
    in
    ()
