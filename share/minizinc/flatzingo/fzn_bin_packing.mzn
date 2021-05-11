predicate fzn_bin_packing(int: c,
                      array[int] of var int: bin,
                      array[int] of int: w) =
        forall( b in lb_array(bin)..ub_array(bin) ) (
            pb_ge_weighted([bin[i] == b | i in index_set(bin)], [w[i] | i in index_set(bin)], c)
        );


%-----------------------------------------------------------------------------%
