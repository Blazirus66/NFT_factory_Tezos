type t =
  | AddAdmin of address
  | RemoveAdmin of address
  | AcceptAdminRole
  | BanUser of address
  | UnbanUser of address
  | WhitelistSelf
  | CreateCollection of nft