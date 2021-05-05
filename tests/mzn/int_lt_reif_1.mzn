var -3..9: a;
var -5..5: b;
var bool: r;
constraint int_lt_reif(a,b,r);
solve satisfy;
