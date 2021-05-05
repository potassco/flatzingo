var -3..9: a;
var -5..5: b;
var -10..10: c;
constraint int_plus(a,b,c);
solve satisfy;
