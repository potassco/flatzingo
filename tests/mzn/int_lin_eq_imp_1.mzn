var -3..9: a;                                                         
var -5..5: b;                                                         
var bool: r;
constraint r -> (3*a + 2*b = 26);
solve satisfy; 
