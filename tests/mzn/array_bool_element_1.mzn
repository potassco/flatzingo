var 1..9: b;
array[1..9] of bool: as = [true, true, false, true, true, false, false, true, true];
var bool: c;
constraint array_bool_element(b,as,c);
solve satisfy;
