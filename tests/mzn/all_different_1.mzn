include "all_different.mzn";
var 0..5: x;                                                         
var 0..5: y;                                                         
var 0..7: z;                                                         
constraint all_different([x,y,z]);
solve satisfy; 
