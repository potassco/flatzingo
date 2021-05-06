var bool: a;
var bool: b;
var bool: r;
constraint r -> bool_eq(a,b);
solve satisfy;
