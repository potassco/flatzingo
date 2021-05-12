predicate fzn_count_eq_par_reif(array[int] of var int: x, var int: y, int: c, var bool: r) =
    pb_eq_reif([x[i] == y | i in index_set(x)], c, r);


