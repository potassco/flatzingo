predicate fzn_count_gt(array[int] of var int: x, var int: y, var int: c) =
    if is_fixed(c) then
      pb_le([x[i] == y | i in index_set(x)], fix(c)-1)
    else
      let { var int: z = count(x,y) } in z < c
    endif;
