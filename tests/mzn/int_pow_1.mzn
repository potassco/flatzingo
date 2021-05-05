var 1..9: a;
var 0..5: b;
var 0..100: c;
constraint int_pow(a,b,c);
solve satisfy;
