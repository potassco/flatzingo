%%% https://www.minizinc.org/doc-2.4.3/en/lib-flatzinc.html#integer-flatzinc-builtins
supported_constraint("int_eq").
supported_constraint("int_eq_reif").
supported_constraint("int_le").
supported_constraint("int_le_reif").
supported_constraint("int_lin_eq").
supported_constraint("int_lin_eq_reif").
supported_constraint("int_lin_le").
supported_constraint("int_lin_le_reif").
supported_constraint("int_lin_ne").
supported_constraint("int_lin_ne_reif").
supported_constraint("int_lt").
supported_constraint("int_lt_reif").
supported_constraint("int_ne").
supported_constraint("int_ne_reif").
supported_constraint("int_plus").
supported_constraint("array_bool_and").
supported_constraint("array_bool_or").
supported_constraint("bool2int").
supported_constraint("bool_and").
supported_constraint("bool_clause").
supported_constraint("bool_eq").
supported_constraint("bool_eq_reif").
supported_constraint("bool_le").
supported_constraint("bool_le_reif").
supported_constraint("bool_lin_eq").
supported_constraint("bool_lin_le").
supported_constraint("bool_lt").
supported_constraint("bool_lt_reif").
supported_constraint("bool_not").
supported_constraint("bool_or").
supported_constraint("bool_xor").
supported_constraint("bool_clause_reif").
supported_constraint("int_eq_imp").
supported_constraint("int_ne_imp").
supported_constraint("int_ge_imp").
supported_constraint("int_gt_imp").
supported_constraint("int_le_imp").
supported_constraint("int_lt_imp").
supported_constraint("int_lin_eq_imp").
supported_constraint("int_lin_le_imp").
supported_constraint("int_lin_ne_imp").
supported_constraint("bool_eq_imp").
supported_constraint("bool_le_imp").
supported_constraint("bool_lt_imp").
supported_constraint("bool_clause_imp").

supported_constraint("int_max").
supported_constraint("int_min").

supported_constraint("array_int_maximum").
supported_constraint("array_int_minimum").

fail(C) :- constraint(C,T), not supported_constraint(T).

supported(V) :- variable(bool,V).
supported(V) :- variable(int,V).
supported(V) :- variable(array(_,int),V).
supported(V) :- variable(array(_,bool),V).
supported(V) :- variable(int_in_range(_,_),V).

fail(Type,V) :- variable(Type,V), not supported(V).

#show fail/1.
#show fail/2.
