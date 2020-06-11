predicate fzn_count_neq_par(array[int] of var int: x, var int: y, int: c) =
    pb_ne([x[i] == y | i in index_set(x)], c);
