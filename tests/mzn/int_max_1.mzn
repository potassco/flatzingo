var -3..9: a;
var -5..5: b;
var 0..7: c;
constraint int_max(a,b,c);
solve satisfy;
