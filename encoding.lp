%%% https://www.minizinc.org/doc-2.4.3/en/lib-flatzinc.html#integer-flatzinc-builtins
%%% we nned to ask questions whether half reification is supported, as this would half the constraints and is usually the case, or check if we can detect them

%%% no supported basic constructs
unsupported(array_int_element).
unsupported(array_int_maximum).
unsupported(array_int_minimum).
unsupported(array_var_int_element).
unsupported(int_abs).
unsupported(int_div).
unsupported(int_max).
unsupported(int_min).
unsupported(int_mod).
unsupported(int_pow).
unsupported(int_pow_fixed).
unsupported(int_times).
unsupported(array_bool_element). % unsure about syntax
unsuported(array_bool_xor). % would need some translation
unsupported(array_var_bool_element). % theory of arrays ?
unsupported(array_set_element).
unsupported(array_var_set_element).
unsupported(set_card).
unsupported(set_diff).
unsupported(set_eq).
unsupported(set_eq_reif).
unsupported(set_in).
unsupported(set_in_reif).
unsupported(set_intersect).
unsupported(set_le).
unsupported(set_le_reif).
unsupported(set_lt).
unsupported(set_lt_reif).
unsupported(set_ne).
unsupported(set_ne_reif).
unsupported(set_subset).
unsupported(set_subset_reif).
unsupported(set_superset).
unsupported(set_symdiff).
unsupported(set_union).
unsupported(array_float_element).
unsupported(array_float_maximum).
unsupported(array_float_minimum).
unsupported(array_var_float_element).
unsupported(float_abs).
unsupported(float_acos).
unsupported(float_acosh).
unsupported(float_asin).
unsupported(float_asinh).
unsupported(float_atan).
unsupported(float_atanh).
unsupported(float_cos).
unsupported(float_cosh).
unsupported(float_div).
unsupported(float_dom).
unsupported(float_eq).
unsupported(float_eq_reif).
unsupported(float_exp).
unsupported(float_in).
unsupported(float_in_reif).
unsupported(float_le).
unsupported(float_le_reif).
unsupported(float_lin_eq).
unsupported(float_lin_eq_reif).
unsupported(float_lin_le).
unsupported(float_lin_le_reif).
unsupported(float_lin_lt).
unsupported(float_lin_lt_reif).
unsupported(float_lin_ne).
unsupported(float_lin_ne_reif).
unsupported(float_ln).
unsupported(float_log10).
unsupported(float_log2).
unsupported(float_lt).
unsupported(float_lt_reif).
unsupported(float_max).
unsupported(float_min).
unsupported(float_ne).
unsupported(float_ne_reif).
unsupported(float_plus).
unsupported(float_pow).
unsupported(float_sin).
unsupported(float_sinh).
unsupported(float_sqrt).
unsupported(float_tan).
unsupported(float_tanh).
unsupported(float_times).
unsupported(int2float).
unsupported(array_float_maximum).
unsupported(array_float_minimum).
unsupported(array_var_bool_element_nonshifted).
unsupported(array_var_int_element_nonshifted).
unsupported(array_var_set_element_nonshifted).

fail(X) :- constraint(C,X), unsupported(X).

var(true).
:- var(false).
{ var(BV) } :- variable(bool, BV).

%% int_eq
:- constraint(C, "int_eq"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   not &sum { X } = Y.

%% int_eq_reif
:- constraint(C, "int_eq_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 1, BV), 
   &sum { X } = Y,
   not var(BV).
:- constraint(C, "int_eq_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 1, BV), 
   not &sum { X } = Y,
   var(BV).

%% int_le
:- constraint(C, "int_le"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   not &sum { X } <= Y.

%% int_le_reif
:- constraint(C, "int_le_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 1, BV), 
   &sum { X } <= Y,
   not var(BV).
:- constraint(C, "int_le_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 1, BV), 
   not &sum { X } <= Y,
   var(BV).

%% int_lin_eq
:- constraint(C, "int_lin_eq"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   not &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } = RHS.

%% int_lin_eq_reif
:- constraint(C, "int_lin_eq_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   in_constraint(C, 3, BV),
   &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } = RHS,
   not var(BV).
:- constraint(C, "int_lin_eq_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   in_constraint(C, 3, BV),
   not &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } = RHS,
   var(BV).

%% int_lin_le
:- constraint(C, "int_lin_le"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   not &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } <= RHS.

%% int_lin_le_reif
:- constraint(C, "int_lin_le_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   in_constraint(C, 3, BV),
   &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } <= RHS,
   not var(BV).
:- constraint(C, "int_lin_le_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   in_constraint(C, 3, BV),
   not &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } <= RHS,
   var(BV).

%% int_lin_ne
:- constraint(C, "int_lin_ne"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   not &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } != RHS.

%% int_lin_ne_reif
:- constraint(C, "int_lin_ne_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   in_constraint(C, 3, BV),
   &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } != RHS,
   not var(BV).
:- constraint(C, "int_lin_ne_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS),
   in_constraint(C, 3, BV),
   not &sum { A*V : in_constraint(C,0,I,A), in_constraint(C,1,I,V) } != RHS,
   var(BV).

%% int_lt
:- constraint(C, "int_lt"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   not &sum { X } < Y.

%% int_lt_reif
:- constraint(C, "int_lt_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 2, BV), 
   &sum { X } < Y,
   not var(BV).
:- constraint(C, "int_lt_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 2, BV), 
   not &sum { X } < Y,
   var(BV).

%% int_ne
:- constraint(C, "int_ne"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   not &sum { X } != Y.

%% int_ne_reif
:- constraint(C, "int_ne_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 2, BV), 
   &sum { X } != Y,
   not var(BV).
:- constraint(C, "int_lt_reif"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 2, BV), 
   not &sum { X } != Y,
   var(BV).

%% int_plus
:- constraint(C, "int_plus"),
   in_constraint(C, 0, X),
   in_constraint(C, 1, Y),
   in_constraint(C, 2, Z),
   not &sum { X + Y } = Z.



%% array_bool_and
:- constraint(C, "array_bool_and"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, B),
   var(BV) : in_constraint(C, 0, I, BV),
   not var(B).
:- constraint(C, "array_bool_and"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, B),
   not var(BV), in_constraint(C, 0, I, BV),
   var(B).

%% array_bool_or
:- constraint(C, "array_bool_or"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, B),
   var(BV), in_constraint(C, 0, I, BV),
   not var(B).
:- constraint(C, "array_bool_or"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, B),
   not var(BV) : in_constraint(C, 0, I, BV),
   var(B).

%% bool2int
:- constraint(C, "bool2int"),
   in_constraint(C, 0, BV),
   in_constraint(C, 1, V),
   &sum {V} = 1,
   not var(BV).
:- constraint(C, "bool2int"),
   in_constraint(C, 0, BV),
   in_constraint(C, 1, V),
   not &sum {V} = 1,
   var(BV).
&dom{0..1} = V :- constraint(C, "bool2int"),
   in_constraint(C, 0, BV),
   in_constraint(C, 1, V).

%% bool_and
:- constraint(C, "bool_and"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A), var(B),
   not var(BV).
:- constraint(C, "bool_and"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), not var(B),
   var(BV).

%% bool_clause
:- constraint(C, "bool_clause"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   not var(BV) : in_constraint(C, 0, I, BV);
   var(BV) : in_constraint(C, 1, I, BV).

%% bool_eq
:- constraint(C, "bool_eq"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   var(A), not var(B).
:- constraint(C, "bool_eq"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   not var(A), var(B).

%% bool_eq_reif
:- constraint(C, "bool_eq_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A), var(B),
   not var(BV).
:- constraint(C, "bool_eq_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), not var(B),
   not var(BV).
:- constraint(C, "bool_eq_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A), not var(B),
   var(BV).
:- constraint(C, "bool_eq_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A), not var(B),
   var(BV).

%% bool_le
:- constraint(C, "bool_le"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   var(A), not var(B).

%% bool_le_reif
:- constraint(C, "bool_le_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A), not var(B),
   var(BV).
:- constraint(C, "bool_le_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(B),
   not var(BV).
:- constraint(C, "bool_le_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), not var(B),
   not var(BV).

%% bool_lin_eq
:- constraint(C, "bool_lin_eq"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS), 
   not #sum {W,BV : var(BV), in_constraint(C, 0, I, W), in_constraint(C, 1, I, BV)} = RHS.

%% bool_lin_le
:- constraint(C, "bool_lin_le"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 2, RHS), 
   not #sum {W,BV : var(BV), in_constraint(C, 0, I, W), in_constraint(C, 1, I, BV)} <= RHS.

%% bool_lt
:- constraint(C, "bool_lt"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   var(A).
var(B):- constraint(C, "bool_lt"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B).

%% bool_lt_reif
:- constraint(C, "bool_lt_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A),
   var(BV).
:- constraint(C, "bool_lt_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), not var(B),
   var(BV).
:- constraint(C, "bool_lt_reif"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), var(B),
   not var(BV).

%% bool_not
:- constraint(C, "bool_not"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   var(A), var(B).
:- constraint(C, "bool_not"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   not var(A), not var(B).

%% bool_or
:- constraint(C, "bool_or"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A),
   not var(BV).
:- constraint(C, "bool_or"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(B),
   not var(BV).
:- constraint(C, "bool_or"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), not var(B),
   var(BV).

%% bool_xor
:- constraint(C, "bool_xor"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A), not var(B),
   not var(BV).
:- constraint(C, "bool_xor"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), var(B),
   not var(BV).
:- constraint(C, "bool_xor"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   not var(A), not var(B),
   var(BV).
:- constraint(C, "bool_xor"),
   in_constraint(C, 0, A),
   in_constraint(C, 1, B),
   in_constraint(C, 2, BV),
   var(A), var(B),
   var(BV).

%% bool_clause
:- constraint(C, "bool_clause_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 1, B), 
   not var(BV) : in_constraint(C, 0, I, BV);
   var(BV) : in_constraint(C, 1, I, BV),
   var(B).
:- constraint(C, "bool_clause_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 1, B), 
   var(BV), in_constraint(C, 0, I, BV),
   not var(B).
:- constraint(C, "bool_clause_reif"),
   in_constraint(C, 0, array), % safety check
   in_constraint(C, 1, array), % safety check
   in_constraint(C, 1, B), 
   not var(BV), in_constraint(C, 1, I, BV),
   not var(B).

&minimize {V : solve(minimize, V)}.
&minimize {-V : solve(maximize, V)}.
