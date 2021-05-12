predicate fzn_count_leq_par(array[int] of var int: x, var int: y, int: c) =
    pb_ge([x[i] == y | i in index_set(x)], c);
