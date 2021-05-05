var -3..9: a;
var -5..5: b;
var -100..100: c;
constraint int_times(a,b,c);
solve satisfy;
