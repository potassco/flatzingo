var 0..4: a;
var 0..13: b;
var -5..2: c;
var -8..-3: d;
var 0..16: m;
constraint m = max([a,b,c,d]);
solve satisfy;
