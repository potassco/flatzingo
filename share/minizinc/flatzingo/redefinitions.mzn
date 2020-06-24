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

%% pb constraints
predicate pb_ge(array[int] of var bool: x, int: v);
predicate pb_le(array[int] of var bool: x, int: v);
predicate pb_eq(array[int] of var bool: x, int: v);
predicate pb_ne(array[int] of var bool: x, int: v);

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

predicate int_times(var int: x, var int: y, var int: z) =
  if is_fixed(x) then
    z==fix(x)*y             %%%%% Need to use fix() otherwise added to CSE & nothing happens
  elseif is_fixed(y) then
    z==x*fix(y)
%  elseif is_same(x, y) then
%    z == pow(x, 2)
  elseif 0..1==dom(x) /\ 0..1==dom(y) then bool_and__INT(x,y,z)
  elseif card(dom(x))==2 /\ card(dom(y))==2 /\ 0 in dom(x) /\ 0 in dom(y)
      then let {
        var 0..1: xn;
        var 0..1: yn;
        var 0..1: zn;
        constraint x=xn*max(dom(x) diff {0});
        constraint y=yn*max(dom(y) diff {0});
        constraint z=zn*max(dom(x) diff {0})*max(dom(y) diff {0});
      } in
      bool_and__INT(xn,yn,zn)
  elseif card(dom(x)) * card(dom(y)) > 20
    \/ ( 
        %% Peter's idea for *bool. More optimal but worse values on carpet cutting.
        (card(dom(x))==2 /\ 0 in dom(x))
        \/ (card(dom(y))==2 /\ 0 in dom(y))
        )
    then                    %% PARAM
    %% ALSO NO POINT IF <=4.          TODO
    if card(dom(x)) > card(dom(y)) \/
      ( card(dom(x))==card(dom(y)) /\ 0 in dom(y) /\ not (0 in dom(x)) )
      then int_times(y,x,z)
    else
      let {
          set of int: s = lb(x)..ub(x),
          set of int: r = {lb(x)*lb(y), lb(x)*ub(y), ub(x)*lb(y), ub(x)*ub(y)},
          array[s] of var min(r)..max(r): ady = array1d(s, [
            if d in dom(x) then d*y else min(r) endif | d in s ]) }
      in
      ady[x] = z                             %% use element()
    endif
  else
    int_times_unary(x, { }, y, z)
  endif;

predicate bool_and__INT(var int: x, var int: y, var int: z) =
    x + y <= z + 1 /\
    %% x + y >= z * 2;         % weak
    x >= z /\ y >= z;     % strong

%% domx__ can be used to narrow domain... NOT IMPL.
predicate int_times_unary(var int: x, set of int: domx__, var int: y, var int: z) =
  let {
    set of int: r = {lb(x)*lb(y), lb(x)*ub(y), ub(x)*lb(y), ub(x)*ub(y)},
    %% set of int: domx = if card(domx__)>0 then domx__ else dom(x) endif,
    array[int, int] of var int: pp=eq_encode(x, y)
  } in
    z>=min(r) /\ z<=max(r) /\
    z==sum(i in index_set_1of2(pp), j in index_set_2of2(pp))
         (i * j * pp[i, j]) /\
    forall(i in index_set_1of2(pp), j in index_set_2of2(pp)
      where not ((i*j) in dom(z))
    )(pp[i, j]==0)
  ;

function array[int, int] of var int: eq_encode(var int: x, var int: y) ::promise_total =
  let {
    array[int] of var int: pX = eq_encode(x),
    array[int] of var int: pY = eq_encode(y),
    array[int, int] of var int: pp = array2d(index_set(pX), index_set(pY),
      [eq_new_var(x,i,y,j) | i in index_set(pX), j in index_set(pY)]);
    constraint equality_encoding(x, y, pX, pY, pp);
  } in pp;

function array[int] of var int: eq_encode(var int: x) ::promise_total =
  let {
    array[int] of var int: y = array1d(lb(x)..ub(x),[eq_new_var(x,i) | i in lb(x)..ub(x)]);
    constraint equality_encoding(x,y);
  } in  y;

function array[int] of int: eq_encode(int: x) ::promise_total =
  array1d(lb(x)..ub(x),[ if i=x then 1 else 0 endif | i in lb(x)..ub(x)]);

    % Two variables:  x = d /\ y = e  <->  x_eq_d[d] /\ y_eq_e[e] /\ xy_eq_de[d, e]
predicate equality_encoding(var int: x, var int: y,
      array[int] of var int: x_eq_d,
      array[int] of var int: y_eq_e,
      array[int, int] of var int: xy_eq_de
      ) =
    x in index_set(x_eq_d) /\
    y in index_set(y_eq_e) /\
    index_set(x_eq_d) == index_set_1of2(xy_eq_de) /\
    index_set(y_eq_e) == index_set_2of2(xy_eq_de) /\
    sum(d in dom(x), e in dom(y))( xy_eq_de[d, e] ) = 1
    /\
    forall(d in dom(x)) (sum(e in dom(y))( xy_eq_de[d, e] ) = x_eq_d[d])
    /\
    forall(e in dom(y)) (sum(d in dom(x))( xy_eq_de[d, e] ) = y_eq_e[e])
    ;

    % Single variable:  x = d  <->  x_eq_d[d]
predicate equality_encoding(var int: x, array[int] of var int: x_eq_d) =
    x in index_set(x_eq_d)
    /\
    sum(d in dom(x))(     x_eq_d[d] ) = 1
    /\
    sum(d in dom(x))( d * x_eq_d[d] ) = x
    ;

function var int: eq_new_var(var int: x, int: i) ::promise_total =
  if i in dom(x) then
  let {
    var 0..1: xi;
  } in xi
  else 0 endif;

%%% The same for 2 variables:
function var int: eq_new_var(var int: x, int: i, var int: y, int: j) ::promise_total =
  if i in dom(x) /\ j in dom(y) then
  let {
    var 0..1: xi;
  } in xi
  else 0 endif;



%%no support for floats
predicate array_float_element(var int: b,
                              array [int] of float: as,
                              var float: c) = abort("floats not supported");
predicate array_float_maximum(var int: m, array [int] of var int: x) = abort("floats not supported");
predicate array_float_minimum(var int: m, array [int] of var int: x) = abort("floats not supported");
predicate array_var_float_element(var int: b,
                                  array [int] of var float: as,
                                  var float: c) = abort("floats not supported");
predicate float_abs(var float: a, var float: b) = abort("floats not supported");
predicate float_acos(var float: a, var float: b) = abort("floats not supported");
predicate float_acosh(var float: a, var float: b) = abort("floats not supported");
predicate float_asin(var float: a, var float: b) = abort("floats not supported");
predicate float_asinh(var float: a, var float: b) = abort("floats not supported");
predicate float_atan(var float: a, var float: b) = abort("floats not supported");
predicate float_atanh(var float: a, var float: b) = abort("floats not supported");
predicate float_cos(var float: a, var float: b) = abort("floats not supported");
predicate float_cosh(var float: a, var float: b) = abort("floats not supported");
predicate float_div(var float: a, var float: b, var float: c) = abort("floats not supported");
predicate float_eq(var float: a, var float: b) = abort("floats not supported");
predicate float_eq_reif(var float: a, var float: b, var bool: r) = abort("floats not supported");
predicate float_exp(var float: a, var float: b) = abort("floats not supported");
predicate float_in_reif(var float: a, float: b, float: c, var bool: r) = abort("floats not supported");
predicate float_le(var float: a, var float: b) = abort("floats not supported");
predicate float_le_reif(var float: a, var float: b, var bool: r) = abort("floats not supported");
predicate float_lin_eq(array [int] of float: as,
                       array [int] of var float: bs,
                       float: c) = abort("floats not supported");
predicate float_lin_eq_reif(array [int] of float: as,
                            array [int] of var float: bs,
                            float: c,
                            var bool: r) = abort("floats not supported");
predicate float_lin_le(array [int] of float: as,
                       array [int] of var float: bs,
                       float: c) = abort("floats not supported");
predicate float_lin_le_reif(array [int] of float: as,
                            array [int] of var float: bs,
                            float: c,
                            var bool: r) = abort("floats not supported");
predicate float_lin_lt(array [int] of float: as,
                       array [int] of var float: bs,
                       float: c) = abort("floats not supported");
predicate float_lin_lt_reif(array [int] of float: as,
                            array [int] of var float: bs,
                            float: c,
                            var bool: r) = abort("floats not supported");
predicate float_lin_ne(array [int] of float: as,
                       array [int] of var float: bs,
                       float: c) = abort("floats not supported");
predicate float_lin_ne_reif(array [int] of float: as,
                            array [int] of var float: bs,
                            float: c,
                            var bool: r) = abort("floats not supported");
predicate float_ln(var float: a, var float: b) = abort("floats not supported");
predicate float_log10(var float: a, var float: b) = abort("floats not supported");
predicate float_log2(var float: a, var float: b) = abort("floats not supported");
predicate float_lt(var float: a, var float: b) = abort("floats not supported");
predicate float_lt_reif(var float: a, var float: b, var bool: r) = abort("floats not supported");
predicate float_max(var float: a, var float: b, var float: c) = abort("floats not supported");
predicate float_min(var float: a, var float: b, var float: c) = abort("floats not supported");
predicate float_ne(var float: a, var float: b) = abort("floats not supported");
predicate float_ne_reif(var float: a, var float: b, var bool: r) = abort("floats not supported");
predicate float_plus(var float: a, var float: b, var float: c) = abort("floats not supported");
predicate float_pow(var float: x, var float: y, var float: z) = abort("floats not supported");
predicate float_sin(var float: a, var float: b) = abort("floats not supported");
predicate float_sinh(var float: a, var float: b) = abort("floats not supported");
predicate float_sqrt(var float: a, var float: b) = abort("floats not supported");
predicate float_tan(var float: a, var float: b) = abort("floats not supported");
predicate float_tanh(var float: a, var float: b) = abort("floats not supported");
predicate float_times(var float: a, var float: b, var float: c) = abort("floats not supported");
predicate int2float(var int: x, var float: y) = abort("floats not supported");

