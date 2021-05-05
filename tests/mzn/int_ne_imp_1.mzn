var -3..9: a;
var -5..5: b;
var bool: r;
constraint int_ne_imp(a,b,r);
solve satisfy;
