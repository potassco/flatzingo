var 0..4: a;                                                         
var 0..13: b;                                                         
var -5..2: c;                                                         
var -8..-3: d;                                                         
var -10..6: m;                                                         
constraint array_int_minimum(m, [a,b,c,d]);                                          
solve satisfy; 
