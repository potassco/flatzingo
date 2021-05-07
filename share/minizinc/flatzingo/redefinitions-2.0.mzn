predicate bool_clause_reif(array[int] of var bool: as,
                           array[int] of var bool: bs,
                           var bool: b);
predicate array_int_maximum(var int: m, array[int] of var int: x);
predicate array_int_maximum_reif(var int: m, array[int] of var int: x, var bool: r);
predicate array_int_maximum_imp(var int: m, array[int] of var int: x, var bool: r);
predicate array_int_minimum(var int: m, array[int] of var int: x);
predicate array_int_minimum_reif(var int: m, array[int] of var int: x, var bool: r);
predicate array_int_minimum_imp(var int: m, array[int] of var int: x, var bool: r);
predicate array_float_maximum(var float, array[int] of var float) =
    abort("floats not supported by this solver");
predicate array_float_minimum(var float, array[int] of var float) =
    abort("floats not supported by this solver");
