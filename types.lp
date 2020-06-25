
constraint_type("int_eq",0,value).
constraint_type("int_eq",1,value).

constraint_type("int_eq_reif",0,value).
constraint_type("int_eq_reif",1,value).
constraint_type("int_eq_reif",2,value).

constraint_type("int_le",0,value).
constraint_type("int_le",1,value).

constraint_type("int_le_reif",0,value).
constraint_type("int_le_reif",1,value).
constraint_type("int_le_reif",2,value).

constraint_type("int_lin_eq",0,array).
constraint_type("int_lin_eq",1,array).
constraint_type("int_lin_eq",2,value).

constraint_type("int_lin_eq_reif",0,array).
constraint_type("int_lin_eq_reif",1,array).
constraint_type("int_lin_eq_reif",2,value).
constraint_type("int_lin_eq_reif",3,value).

constraint_type("int_lin_le",0,array).
constraint_type("int_lin_le",1,array).
constraint_type("int_lin_le",2,value).

constraint_type("int_lin_le_reif",0,array).
constraint_type("int_lin_le_reif",1,array).
constraint_type("int_lin_le_reif",2,value).
constraint_type("int_lin_le_reif",3,value).

constraint_type("int_lin_ne",0,array).
constraint_type("int_lin_ne",1,array).
constraint_type("int_lin_ne",2,value).

constraint_type("int_lin_ne_reif",0,array).
constraint_type("int_lin_ne_reif",1,array).
constraint_type("int_lin_ne_reif",2,value).
constraint_type("int_lin_ne_reif",3,value).

constraint_type("int_lt",0,value).
constraint_type("int_lt",1,value).

constraint_type("int_lt_reif",0,value).
constraint_type("int_lt_reif",1,value).
constraint_type("int_lt_reif",2,value).

constraint_type("int_ne",0,value).
constraint_type("int_ne",1,value).

constraint_type("int_ne_reif",0,value).
constraint_type("int_ne_reif",1,value).
constraint_type("int_ne_reif",2,value).

constraint_type("int_lin_eq_imp",0,array).
constraint_type("int_lin_eq_imp",1,array).
constraint_type("int_lin_eq_imp",2,value).
constraint_type("int_lin_eq_imp",3,value).

constraint_type("int_lin_le_imp",0,array).
constraint_type("int_lin_le_imp",1,array).
constraint_type("int_lin_le_imp",2,value).
constraint_type("int_lin_le_imp",3,value).

constraint_type("int_lin_ne_imp",0,array).
constraint_type("int_lin_ne_imp",1,array).
constraint_type("int_lin_ne_imp",2,value).
constraint_type("int_lin_ne_imp",3,value).

constraint_type("int_plus",0,value).
constraint_type("int_plus",1,value).
constraint_type("int_plus",2,value).

constraint_type("int_eq_imp",0,value).
constraint_type("int_eq_imp",1,value).
constraint_type("int_eq_imp",2,value).

constraint_type("int_ne_imp",0,value).
constraint_type("int_ne_imp",1,value).
constraint_type("int_ne_imp",2,value).

constraint_type("int_ge_imp",0,value).
constraint_type("int_ge_imp",1,value).
constraint_type("int_ge_imp",2,value).

constraint_type("int_gt_imp",0,value).
constraint_type("int_gt_imp",1,value).
constraint_type("int_gt_imp",2,value).

constraint_type("int_le_imp",0,value).
constraint_type("int_le_imp",1,value).
constraint_type("int_le_imp",2,value).

constraint_type("int_lt_imp",0,value).
constraint_type("int_lt_imp",1,value).
constraint_type("int_lt_imp",2,value).

constraint_type("array_bool_and",0,array).
constraint_type("array_bool_and",1,value).

constraint_type("array_bool_or",0,array).
constraint_type("array_bool_or",1,value).

constraint_type("bool2int",0,value).
constraint_type("bool2int",1,value).

constraint_type("bool_and",0,value).
constraint_type("bool_and",1,value).
constraint_type("bool_and",2,value).

constraint_type("bool_clause",0,array).
constraint_type("bool_clause",1,array).

constraint_type("bool_eq",0,value).
constraint_type("bool_eq",1,value).

constraint_type("bool_eq_reif",0,value).
constraint_type("bool_eq_reif",1,value).
constraint_type("bool_eq_reif",2,value).

constraint_type("bool_le",0,value).
constraint_type("bool_le",1,value).

constraint_type("bool_le_reif",0,value).
constraint_type("bool_le_reif",1,value).
constraint_type("bool_le_reif",2,value).

constraint_type("bool_lin_eq",0,array).
constraint_type("bool_lin_eq",1,array).
constraint_type("bool_lin_eq",2,value).

constraint_type("bool_lin_ne",0,array).
constraint_type("bool_lin_ne",1,array).
constraint_type("bool_lin_ne",2,value).

constraint_type("bool_lin_le",0,array).
constraint_type("bool_lin_le",1,array).
constraint_type("bool_lin_le",2,value).

constraint_type("bool_lt",0,value).
constraint_type("bool_lt",1,value).

constraint_type("bool_lt_reif",0,value).
constraint_type("bool_lt_reif",1,value).
constraint_type("bool_lt_reif",2,value).

constraint_type("bool_not",0,value).
constraint_type("bool_not",1,value).

constraint_type("bool_or",0,value).
constraint_type("bool_or",1,value).
constraint_type("bool_or",2,value).

%% can be two OR three params -> thats bad and against minizinc rules
constraint_type("bool_xor",0,value).
constraint_type("bool_xor",1,value).
constraint_type("bool_xor",2,value).

constraint_type("bool_clause_reif",0,array).
constraint_type("bool_clause_reif",1,array).
constraint_type("bool_clause_reif",2,value).

constraint_type("bool_eq_imp",0,value).
constraint_type("bool_eq_imp",1,value).
constraint_type("bool_eq_imp",2,value).

constraint_type("bool_le_imp",0,value).
constraint_type("bool_le_imp",1,value).
constraint_type("bool_le_imp",2,value).

constraint_type("bool_lt_imp",0,value).
constraint_type("bool_lt_imp",1,value).
constraint_type("bool_lt_imp",2,value).

constraint_type("bool_clause_imp",0,array).
constraint_type("bool_clause_imp",1,array).
constraint_type("bool_clause_imp",2,value).

constraint_type("int_max",0,value).
constraint_type("int_max",1,value).
constraint_type("int_max",2,value).

constraint_type("int_min",0,value).
constraint_type("int_min",1,value).
constraint_type("int_min",2,value).

constraint_type("array_int_maximum",0,value).
constraint_type("array_int_maximum",1,array).

constraint_type("array_int_minimum",0,value).
constraint_type("array_int_minimum",1,array).

constraint_type("array_different",0,array).

constraint_type("flatzingo_fixed_disjunctive",0,array).
constraint_type("flatzingo_fixed_disjunctive",1,array).

constraint_type("set_in",0,value).
constraint_type("set_in",1,set).

constraint_type("set_in_imp",0,value).
constraint_type("set_in_imp",1,set).
constraint_type("set_in_imp",2,value).

constraint_type("set_in_reif",0,value).
constraint_type("set_in_reif",1,set).
constraint_type("set_in_reif",2,value).

constraint_type("pb_ge",0,array).
constraint_type("pb_ge",1,value).

constraint_type("pb_le",0,array).
constraint_type("pb_le",1,value).

constraint_type("pb_eq",0,array).
constraint_type("pb_eq",1,value).

constraint_type("pb_ne",0,array).
constraint_type("pb_ne",1,value).
