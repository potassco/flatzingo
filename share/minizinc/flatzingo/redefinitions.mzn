include "nosets.mzn";

%% support all kinds of half-reifications
predicate int_eq_imp(var int: a, var int: b, var bool: r);
predicate int_ne_imp(var int: a, var int: b, var bool: r);
predicate int_ge_imp(var int: a, var int: b, var bool: r);
predicate int_gt_imp(var int: a, var int: b, var bool: r);
predicate int_le_imp(var int: a, var int: b, var bool: r);
predicate int_lt_imp(var int: a, var int: b, var bool: r);
predicate int_lin_eq_imp(array[int] of int: c, array[int] of var int: x, int: d, var bool: b);
predicate int_lin_le_imp(array[int] of int: c, array[int] of var int: x, int: d, var bool: b);
predicate int_lin_ne_imp(array[int] of int: c, array[int] of var int: x, int: d, var bool: b);
predicate bool_eq_imp(var bool: p, var bool: q, var bool: r);
predicate bool_lt_imp(var bool: p, var bool: q, var bool: r);
predicate bool_le_imp(var bool: p, var bool: q, var bool: r);
predicate bool_clause_reif(array[int] of var bool: p, array[int] of var bool: n, var bool: c);

%% non-linear functions
%% write a translation for int_min/max and its array version inside the solver
predicate array_int_maximum(var int: m, array[int] of var int: x);
predicate array_int_minimum(var int: m, array[int] of var int: x);

%%% Big thanks to Gleb Belov for this translation
predicate array_int_element(var int: i00, array[int] of int: a, var int: z) =
    let {
      set of int: ix = index_set(a),
      constraint i00 in { i | i in ix where a[i] in dom(z) },
    } in         %%% Tighten domain of i00 before dMin/dMax
    let {
          int: dMin = min(i in dom(i00))(a[i]),
          int: dMax = max(i in dom(i00))(a[i]),
    } in
    if dMin==dMax then
      z==dMin
    else
      z >= dMin /\
      z <= dMax /\
      let {
        int: nUBi00 = max(dom(i00)),
        int: nLBi00 = min(dom(i00)),
        int: nMinDist = min(i in nLBi00 .. nUBi00-1)(a[i+1]-a[i]),
        int: nMaxDist = max(i in nLBi00 .. nUBi00-1)(a[i+1]-a[i]),
      } in
      if nMinDist == nMaxDist then               %% The linear case
        z == a[nLBi00] + nMinDist*(i00-nLBi00)
      else
        sum(i in dom(i00))( a[i] * (i==i00) ) == z
      endif
    endif;

predicate array_var_int_element(var int: i00, array[int] of var int: a,
                                var int: z) =
    let {
      constraint i00 in { i | i in index_set(a) where
        0 < card(dom(a[i]) intersect dom(z)) },
    } in                            %% finish domain first
    let {
          int: minLB=min(i in dom(i00))(lb(a[i])),
          int: maxUB=max(i in dom(i00))(ub(a[i]))
    } in
    if minLB==maxUB then
      z==minLB
    else
      z >= minLB /\
      z <= maxUB /\
      if {0,1}==dom(i00) then
        int_eq_imp(z, a[lb(i00)], (ub(i00)-i00)==1) /\
        int_eq_imp(z, a[ub(i00)], (i00-lb(i00))==1)
      else
        forall (i in dom(i00))(
          int_eq_imp(z, a[i], (i==i00))
        )
      endif
    endif;

predicate array_bool_element(var int: x, array[int] of bool: a, var bool: z) =
    array_int_element(x, arrayXd(a, [bool2int(a[i]) | i in index_set(a)]), bool2int(z));

predicate array_var_bool_element(var int: x, array[int] of var bool: a,
                                 var bool: z) =
    array_var_int_element(x, arrayXd(a, [bool2int(a[i]) | i in index_set(a)]), bool2int(z));

%% translation of xor taken from https://github.com/chuffed
predicate array_bool_xor(array[int] of var bool: bs) =
    let { int: bs_lower = min(index_set(bs)),
          int: bs_upper = max(index_set(bs)),
          int: n = length(bs)
    } in
        if n == 1 then bs[bs_lower] else
        if n == 2 then bs[bs_lower] xor bs[bs_upper] else
        if n == 3 then bs[bs_lower] = (bs[bs_lower + 1] = bs[bs_upper])
        else
            let { int: cs_lower = bs_lower + 1,
                  int: cs_upper = bs_upper - 1,
                  array [cs_lower..cs_upper] of var bool: cs
            } in
                forall(i in cs_lower..cs_upper-1)(
                    cs[i+1] = bs[i+1] xor cs[i]
                )
                /\ (cs[cs_lower] = bs[bs_lower] xor bs[bs_lower + 1])
                /\ (bs[bs_upper] xor cs[cs_upper])
        endif endif endif;

%% some non-linear stuff that can be translated away
predicate int_abs(var int: x, var int: z) =
  if lb(x)>=0 then z==x
  elseif ub(x)<=0 then z==-x
  else
    let { var bool: p }
    in
    z >=  x /\
    z >= -x /\
    z >= 0 /\                         % This is just for preprocessor
    z <= max([ub(x), -lb(x)]) /\      % And this
    % z <= x \/ z <= -x      %% simple
    int_le_reif(z, x, p) /\ 
    int_le_reif(z, -x, not p) /\
    int_le_reif(0, x, p)   % with reifs
  endif
  ;

predicate int_div(var int: x, var int: y, var int: q) =
    q == aux_int_division_modulo_fn(x,y)[1];

predicate int_mod(var int: x, var int: y, var int: r) =
    r == aux_int_division_modulo_fn(x,y)[2];

function array[int] of var int: aux_int_division_modulo_fn(var int: x, var int: y) =
    let {
      %% Domain of q
      set of int: dom_q =
        if lb(y)*ub(y)>0 then
          let {
            set of int: EP = { ub(x) div ub(y), ub(x) div lb(y), lb(x) div ub(y), lb(x) div lb(y) },
          } in min(EP)..max(EP)
        else
          let {
            int: mm = max( abs(lb(x)), abs(ub(x)) ),
          } in -mm..mm                   %% TODO case when -1 or 1 not in dom(x)
        endif,
      var dom_q: q;
      int: by = max(abs(lb(y)), abs(ub(y)));
      var -by+1..by-1: r;
      constraint x = y * q + r,
      constraint 0 <= x -> 0 <= r,  %%  which is    0 > x \/ 0 <= r
      constraint x < 0 -> r <= 0,   %%  which is    x >= 0 \/ r <= 0
    % abs(r) < abs(y)
      var 1.. max(abs(lb(y)), abs(ub(y))): w = abs(y),
      constraint w >  r /\ w > -r,
    } in
      [ q, r ];

predicate int_pow( var int: x, var int: y, var int: r ) =
    let {
      array[ int, int ] of int: x2y = array2d( lb(x)..ub(x), lb(y)..ub(y),
        [ pow( X, Y ) | X in lb(x)..ub(x), Y in lb(y)..ub(y) ] )
    } in
      r == x2y[ x, y ];


%% somehow assert that I do not support int_times or find a suitable translation
