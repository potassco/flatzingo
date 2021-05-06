var bool: a;
var bool: b;
var bool: r;
constraint r -> bool_lt(a,b);
solve satisfy;
