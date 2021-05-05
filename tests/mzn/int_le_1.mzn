var -3..9: a;
var -5..5: b;
constraint int_le(a,b);
solve satisfy;
