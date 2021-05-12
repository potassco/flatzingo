var -3..9: a;
var -5..5: b;
var 0..8: c;
array[1..3] of var int: as = [a,b,c];
var bool: r;
constraint r -> count_gt(as,7,2);
solve satisfy;
