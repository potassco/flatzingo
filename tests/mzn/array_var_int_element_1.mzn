var 1..5: b;                                                         
var -5..13: c;                                                         
var 0..5: a1;
var -3..3: a2;
var -1..6: a3;
var 3..5: a4;
var 3..5: a5;
constraint array_var_int_element(b,[a1,a2,a3,a4,a5],c);                                          
solve satisfy; 
