predicate fzn_count_lt_par_reif(array[int] of var int: x, var int: y, int: c, var bool: r) =
    pb_ge_reif([x[i] == y | i in index_set(x)], c+1, r);
