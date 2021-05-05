var 1..5: b;
var 0..13: c;
constraint array_int_element(b,[1,2,4,6,12],c);
solve satisfy;
