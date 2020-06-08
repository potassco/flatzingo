%%% TODO: parameters can occur wherever variables can, but not wise versa
%%%convert((Name,X)parameter(array(N,_),Name).
array_expected("int_lin_eq",(0;1)).
array_expected("int_lin_eq_reif",(0;1)).
array_expected("int_lin_le",(0;1)).
array_expected("int_lin_le_reif",(0;1)).
array_expected("int_lin_ne",(0;1)).
array_expected("int_lin_ne_reif",(0;1)).
array_expected("array_bool_and",0).
array_expected("array_bool_or",0).
array_expected("bool_clause",(0;1)).
array_expected("bool_lin_eq",(0;1)).
array_expected("bool_lin_le",(0;1)).
array_expected("bool_clause_reif",(0;1)).

in(C,I,array) :- in_constraint(C,I,array).
in(C,I,X,V)   :- in_constraint(C,I,X,V).
in(C,I,V)     :- in_constraint(C,I,V), constraint(C,Type), not array_expected(Type,I).

in(C,I,X,V)   :- in_constraint(C,I,A), A!=array, constraint(C,Type), array_expected(Type,I),
                 in_array(A,X,V).
in(C,I,array) :- in_constraint(C,I,A), A!=array, constraint(C,Type), array_expected(Type,I).

var(true).
:- var(false).
{ var(BV) } :- variable(bool, BV).
&dom {L..U} = V :- variable(int_in_range(L,U), V).

%% int_eq
:- constraint(C, "int_eq"),
   in(C, 0, X),
   in(C, 1, Y),
   not &sum { X } = Y.

%% int_eq_reif
:- constraint(C, "int_eq_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 1, BV), 
   &sum { X } = Y,
   not var(BV).
:- constraint(C, "int_eq_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 1, BV), 
   not &sum { X } = Y,
   var(BV).

%% int_le
:- constraint(C, "int_le"),
   in(C, 0, X),
   in(C, 1, Y),
   not &sum { X } <= Y.

%% int_le_reif
:- constraint(C, "int_le_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 1, BV), 
   &sum { X } <= Y,
   not var(BV).
:- constraint(C, "int_le_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 1, BV), 
   not &sum { X } <= Y,
   var(BV).

%% int_lin_eq
:- constraint(C, "int_lin_eq"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   not &sum { A*V : in(C,0,I,A), in(C,1,I,V) } = RHS.

%% int_lin_eq_reif
:- constraint(C, "int_lin_eq_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   in(C, 3, BV),
   &sum { A*V : in(C,0,I,A), in(C,1,I,V) } = RHS,
   not var(BV).
:- constraint(C, "int_lin_eq_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   in(C, 3, BV),
   not &sum { A*V : in(C,0,I,A), in(C,1,I,V) } = RHS,
   var(BV).

%% int_lin_le
:- constraint(C, "int_lin_le"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   not &sum { A*V : in(C,0,I,A), in(C,1,I,V) } <= RHS.

%% int_lin_le_reif
:- constraint(C, "int_lin_le_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   in(C, 3, BV),
   &sum { A*V : in(C,0,I,A), in(C,1,I,V) } <= RHS,
   not var(BV).
:- constraint(C, "int_lin_le_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   in(C, 3, BV),
   not &sum { A*V : in(C,0,I,A), in(C,1,I,V) } <= RHS,
   var(BV).

%% int_lin_ne
:- constraint(C, "int_lin_ne"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   not &sum { A*V : in(C,0,I,A), in(C,1,I,V) } != RHS.

%% int_lin_ne_reif
:- constraint(C, "int_lin_ne_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   in(C, 3, BV),
   &sum { A*V : in(C,0,I,A), in(C,1,I,V) } != RHS,
   not var(BV).
:- constraint(C, "int_lin_ne_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS),
   in(C, 3, BV),
   not &sum { A*V : in(C,0,I,A), in(C,1,I,V) } != RHS,
   var(BV).

%% int_lt
:- constraint(C, "int_lt"),
   in(C, 0, X),
   in(C, 1, Y),
   not &sum { X } < Y.

%% int_lt_reif
:- constraint(C, "int_lt_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 2, BV), 
   &sum { X } < Y,
   not var(BV).
:- constraint(C, "int_lt_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 2, BV), 
   not &sum { X } < Y,
   var(BV).

%% int_ne
:- constraint(C, "int_ne"),
   in(C, 0, X),
   in(C, 1, Y),
   not &sum { X } != Y.

%% int_ne_reif
:- constraint(C, "int_ne_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 2, BV), 
   &sum { X } != Y,
   not var(BV).
:- constraint(C, "int_ne_reif"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 2, BV), 
   not &sum { X } != Y,
   var(BV).

%% int_plus
:- constraint(C, "int_plus"),
   in(C, 0, X),
   in(C, 1, Y),
   in(C, 2, Z),
   not &sum { X + Y } = Z.



%% array_bool_and
:- constraint(C, "array_bool_and"),
   in(C, 0, array), % safety check
   in(C, 1, B),
   var(BV) : in(C, 0, I, BV),
   not var(B).
:- constraint(C, "array_bool_and"),
   in(C, 0, array), % safety check
   in(C, 1, B),
   not var(BV), in(C, 0, I, BV),
   var(B).

%% array_bool_or
:- constraint(C, "array_bool_or"),
   in(C, 0, array), % safety check
   in(C, 1, B),
   var(BV), in(C, 0, I, BV),
   not var(B).
:- constraint(C, "array_bool_or"),
   in(C, 0, array), % safety check
   in(C, 1, B),
   not var(BV) : in(C, 0, I, BV),
   var(B).

%% bool2int
:- constraint(C, "bool2int"),
   in(C, 0, BV),
   in(C, 1, V),
   &sum {V} = 1,
   not var(BV).
:- constraint(C, "bool2int"),
   in(C, 0, BV),
   in(C, 1, V),
   not &sum {V} = 1,
   var(BV).
&dom{0..1} = V :- constraint(C, "bool2int"),
   in(C, 0, BV),
   in(C, 1, V).

%% bool_and
:- constraint(C, "bool_and"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A), var(B),
   not var(BV).
:- constraint(C, "bool_and"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), not var(B),
   var(BV).

%% bool_clause
:- constraint(C, "bool_clause"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   not var(BV) : in(C, 0, I, BV);
   var(BV) : in(C, 1, I, BV).

%% bool_eq
:- constraint(C, "bool_eq"),
   in(C, 0, A),
   in(C, 1, B),
   var(A), not var(B).
:- constraint(C, "bool_eq"),
   in(C, 0, A),
   in(C, 1, B),
   not var(A), var(B).

%% bool_eq_reif
:- constraint(C, "bool_eq_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A), var(B),
   not var(BV).
:- constraint(C, "bool_eq_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), not var(B),
   not var(BV).
:- constraint(C, "bool_eq_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A), not var(B),
   var(BV).
:- constraint(C, "bool_eq_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A), not var(B),
   var(BV).

%% bool_le
:- constraint(C, "bool_le"),
   in(C, 0, A),
   in(C, 1, B),
   var(A), not var(B).

%% bool_le_reif
:- constraint(C, "bool_le_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A), not var(B),
   var(BV).
:- constraint(C, "bool_le_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(B),
   not var(BV).
:- constraint(C, "bool_le_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), not var(B),
   not var(BV).

%% bool_lin_eq
:- constraint(C, "bool_lin_eq"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS), 
   not #sum {W,BV : var(BV), in(C, 0, I, W), in(C, 1, I, BV)} = RHS.

%% bool_lin_ne
:- constraint(C, "bool_lin_ne"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS), 
   not #sum {W,BV : var(BV), in(C, 0, I, W), in(C, 1, I, BV)} != RHS.

%% bool_lin_le
:- constraint(C, "bool_lin_le"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 2, RHS), 
   not #sum {W,BV : var(BV), in(C, 0, I, W), in(C, 1, I, BV)} <= RHS.

%% bool_lt
:- constraint(C, "bool_lt"),
   in(C, 0, A),
   in(C, 1, B),
   var(A).
var(B):- constraint(C, "bool_lt"),
   in(C, 0, A),
   in(C, 1, B).

%% bool_lt_reif
:- constraint(C, "bool_lt_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A),
   var(BV).
:- constraint(C, "bool_lt_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), not var(B),
   var(BV).
:- constraint(C, "bool_lt_reif"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), var(B),
   not var(BV).

%% bool_not
:- constraint(C, "bool_not"),
   in(C, 0, A),
   in(C, 1, B),
   var(A), var(B).
:- constraint(C, "bool_not"),
   in(C, 0, A),
   in(C, 1, B),
   not var(A), not var(B).

%% bool_or
:- constraint(C, "bool_or"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A),
   not var(BV).
:- constraint(C, "bool_or"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(B),
   not var(BV).
:- constraint(C, "bool_or"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), not var(B),
   var(BV).

%% bool_xor
:- constraint(C, "bool_xor"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A), not var(B),
   not var(BV).
:- constraint(C, "bool_xor"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), var(B),
   not var(BV).
:- constraint(C, "bool_xor"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   not var(A), not var(B),
   var(BV).
:- constraint(C, "bool_xor"),
   in(C, 0, A),
   in(C, 1, B),
   in(C, 2, BV),
   var(A), var(B),
   var(BV).

:- constraint(C, "bool_xor"),
   in(C, 0, A),
   in(C, 1, B),
   not in(C, 2, _),
   not var(A), not var(B).

:- constraint(C, "bool_xor"),
   in(C, 0, A),
   in(C, 1, B),
   not in(C, 2, _),
   var(A), var(B).


%% bool_clause
:- constraint(C, "bool_clause_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 1, B), 
   not var(BV) : in(C, 0, I, BV);
   var(BV) : in(C, 1, I, BV),
   var(B).
:- constraint(C, "bool_clause_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 1, B), 
   var(BV), in(C, 0, I, BV),
   not var(B).
:- constraint(C, "bool_clause_reif"),
   in(C, 0, array), % safety check
   in(C, 1, array), % safety check
   in(C, 1, B), 
   not var(BV), in(C, 1, I, BV),
   not var(B).

&minimize {V : solve(minimize, V)}.
&minimize {-V : solve(maximize, V)}.
