type t = {
    admin : address;
    pending_admins : address list;
    banned_users : address list;
    whitelisted_creators : address list;
    collections : collections;
}
