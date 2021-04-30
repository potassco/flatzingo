var -2..2: x;                                                         
var -10..10: y;                                                         
constraint int_abs(x,y);                                          
solve satisfy; 
