predicate fzn_count_lt_par(array[int] of var int: x, var int: y, int: c) =
    pb_le([x[i] == y | i in index_set(x)], c-1);
