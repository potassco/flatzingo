%-----------------------------------------------------------------------------%
% A table constraint table(x, t) represents the constraint x in t where we
% consider each row in t to be a tuple and t as a set of tuples.
%-----------------------------------------------------------------------------%
predicate fzn_table_int_reif(array[int] of var int: x, array[int, int] of int: t, var bool: r) =
  let {
    % Introduce row activation variables
    array[index_set_1of2(t)] of var bool: b;
    constraint forall(j in index_set_1of2(t)) (
      pb_eq_reif([t[j,i]=x[i] | i in index_set(x)], length(x), b[j])
    );
  } in pb_ge_reif(b, 1, r);

