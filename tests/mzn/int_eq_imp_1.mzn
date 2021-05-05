var -3..9: a;
var -5..5: b;
var bool: r;
constraint int_eq_imp(a,b,r);
solve satisfy;
