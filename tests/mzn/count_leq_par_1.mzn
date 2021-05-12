var -3..9: a;
var -5..5: b;
var 0..8: c;
array[1..3] of var int: as = [a,b,c];
%constraint sum (i in index_set(as))(as[i] == 7) == 2;
constraint count_leq(as,7,2);
solve satisfy;
