predicate fzn_bin_packing_reif(int: c,
                      array[int] of var int: bin,
                      array[int] of int: w,
                      var bool: b) =
        forall( assigned_bin in lb_array(bin)..ub_array(bin) ) (
            pb_le_weighted_reif([bin[i] == assigned_bin | i in index_set(bin)], [w[i] | i in index_set(bin)], c, b)
        );

%-----------------------------------------------------------------------------%
