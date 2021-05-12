predicate fzn_count_neq_par_reif(array[int] of var int: x, var int: y, int: c, var bool: r) =
    pb_ne_reif([x[i] == y | i in index_set(x)], c, r);
