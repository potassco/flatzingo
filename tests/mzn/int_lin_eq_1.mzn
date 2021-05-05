var -3..9: a;
var -5..5: b;
constraint int_lin_eq([3,2], [a,b], 26);
solve satisfy;
