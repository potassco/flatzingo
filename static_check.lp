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

supported_constraint("all_different_int").
supported_constraint("flatzingo_fixed_disjunctive").

supported_constraint("set_in").
supported_constraint("set_in_imp").
supported_constraint("set_in_reif").

supported_constraint("pb_ge").
supported_constraint("pb_le").
supported_constraint("pb_eq").
supported_constraint("pb_ne").

#include "types.lp".

fail(C) :- constraint(C,T), not supported_constraint(T).

supported(V) :- variable_type(V,bool).
supported(V) :- variable_type(V,int).
supported(V) :- variable_type(V,int, set, _).
supported(V) :- variable_type(V,array(_,int)).
supported(V) :- variable_type(V,array(_,bool)).

fail(Type,V) :- variable_type(V,Type), not supported(V).
fail(Type,V) :- variable_type(V,Type,_), not supported(V).

fail(C,T) :- constraint(C,T), constraint_type(T,I,value),
             constraint_value(C,I,array,_).
fail(C,T) :- constraint(C,T), constraint_type(T,I,value),
             constraint_value(C,I,set,_).

fail(C,T) :- constraint(C,T), constraint_type(T,I,array),
             constraint_value(C,I,value,_).
fail(C,T) :- constraint(C,T), constraint_type(T,I,array),
             constraint_value(C,I,set,_).

fail(C,T) :- constraint(C,T), constraint_type(T,I,set),
             constraint_value(C,I,value,_).
fail(C,T) :- constraint(C,T), constraint_type(T,I,set),
             constraint_value(C,I,array,_).

#show fail/1.
#show fail/2.

numVar(bool,X) :- X = #sum {1,V : variable_type(V,bool)}.
numVar(int,X) :- X = #sum {1,V : variable_type(V,int); 1,V : variable_type(V,int_in_range(_,_)); 1,V : variable_type(V, int_in_set(_))}.
numConstraint(T,X) :- constraint(_,T), X = #sum {1,C : constraint(C,T)}.

#show numVar/2.
#show numConstraint/2.
