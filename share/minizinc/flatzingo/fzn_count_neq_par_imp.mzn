predicate fzn_count_neq_par_imp(array[int] of var int: x, var int: y, int: c, var bool: r) =
    pb_ne_imp([x[i] == y | i in index_set(x)], c, r);
