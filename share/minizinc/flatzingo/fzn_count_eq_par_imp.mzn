predicate fzn_count_eq_par_imp(array[int] of var int: x, var int: y, int: c, var bool: r) =
    pb_eq_imp([x[i] == y | i in index_set(x)], c, r);


