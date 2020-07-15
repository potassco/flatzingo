%-----------------------------------------------------------------------------%
% A table constraint table(x, t) represents the constraint x in t where we
% consider each row in t to be a tuple and t as a set of tuples.
%-----------------------------------------------------------------------------%

predicate fzn_table_int(array[int] of var int: x, array[int, int] of int: t) =
    let { int: l = min(index_set(x)),
          int: u = max(index_set(x)),
          int: lt = min(index_set_1of2(t)),
          int: ut = max(index_set_1of2(t)),
          array[lt..ut] of var bool: b}
    in
        forall(j in lt..ut) (
            pb_eq_imp([t[j,i]=x[i] | i in l..u], u-l+1, b[j])
        ) /\
        forall(j in index_set(x)) (
            set_in(x[j], {t[i,j] | i in index_set_1of2(t)})
        ) /\
        pb_eq(b,1);

%-----------------------------------------------------------------------------%
