%-----------------------------------------------------------------------------%
% A table constraint table(x, t) represents the constraint x in t where we
% consider each row in t to be a tuple and t as a set of tuples.
%-----------------------------------------------------------------------------%
predicate fzn_table_int(array[int] of var int: x, array[int, int] of int: t) =
  let {
    % Introduce row activation variables
    array[index_set_1of2(t)] of var bool: b;
    constraint forall(j in index_set_1of2(t)) (
      pb_eq_imp([t[j,i]=x[i] | i in index_set(x)], length(x), b[j])
    );
    % Optional: Limit domains of x
    constraint forall(i in index_set(x)) (
      x[i] in { t[j,i] | j in index_set_1of2(t) }
    );
  } in pb_eq(b, 1); % One row must be activated

