var bool: a1;
var bool: a2;
var bool: a3;
var bool: a4;
var bool: r;
var -10..12: c;
constraint r <-> bool_lin_eq([3,-2,-5,8],[a1,a2,a3,a4],c);
solve satisfy;
