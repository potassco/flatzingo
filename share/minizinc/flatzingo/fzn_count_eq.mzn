predicate fzn_count_eq(array[int] of var int: x, var int: y, var int: c) =
    if is_fixed(c) then
      pb_eq([x[i] == y | i in index_set(x)], fix(c))
    else
      let { var int: z = count(x,y) } in z == c
    endif;


