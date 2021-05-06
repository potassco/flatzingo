var bool: a;
var bool: b;
var bool: r;
constraint r -> bool_le(a,b);
solve satisfy;
