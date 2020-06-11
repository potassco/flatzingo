predicate fzn_count_leq_par(array[int] of var int: x, var int: y, int: c) =
    pb_le([x[i] == y | i in index_set(x)], c);
