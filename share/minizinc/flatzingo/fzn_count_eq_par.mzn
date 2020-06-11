predicate fzn_count_eq_par(array[int] of var int: x, var int: y, int: c) =
    pb_eq([x[i] == y | i in index_set(x)], c);


