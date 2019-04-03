set precmd_list { "make_datetime.tcl" }

foreach item $precmd_list {
    post_message "execute $item"
    exec quartus_sh -t $item
}
