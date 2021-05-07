var 0..4: a;
var 0..5: b;
var -5..2: c;
var -8..-3: d;
var 0..8: m;
var bool: r;
constraint r -> m = max([a,b,c,d]);
solve satisfy;
