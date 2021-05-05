var -3..9: a;
var -5..5: b;
var bool: r;
constraint int_lin_eq_reif([3,2], [a,b], 26, r);
solve satisfy;
