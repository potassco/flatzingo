var bool: a1;
var bool: a2;
var bool: a3;
var bool: a4;
constraint bool_lin_eq([3,-2,-5,8],[a1,a2,a3,a4],10);
solve satisfy;
