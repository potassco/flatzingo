int: a;                                                                
var 1..100: x;                                                         
constraint a <= x /\ x < 2*a;                                          
solve :: int_search([x], input_order, indomain_min, complete) satisfy; 
