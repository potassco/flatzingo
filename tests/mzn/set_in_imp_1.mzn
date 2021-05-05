var -10..130: a;
var bool: r;
constraint r -> set_in(a,{-4,3,4,5,123});
solve satisfy;
