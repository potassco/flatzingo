predicate flatzingo_all_different_int(array[int] of var int: x);

predicate fzn_all_different_int(array[int] of var int: x) =
  flatzingo_all_different_int(x);

