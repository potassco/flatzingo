var -3..9: a;
var -5..5: b;
var 0..7: c;
constraint b != 0;
constraint int_mod(a,b,c);
solve satisfy;
