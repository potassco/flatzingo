predicate fzn_cumulative(array[int] of var int: s,
                     array[int] of var int: d,
                     array[int] of var int: r, var int: b) =
        let { 
            set of int: Tasks = 
                {i | i in index_set(s) where ub(r[i]) > 0 /\ ub(d[i]) > 0 }
        } in
            if 0==card(Tasks) then /*true*/ 0==card(index_set(s)) \/ b>=0
            else
                let {
                    int: early = min([ lb(s[i])            | i in Tasks ]), 
                    int: late  = max([ ub(s[i]) + ub(d[i]) | i in Tasks ]) 
                } in (
                    if late - early > 5000 then
                      fzn_cumulative_task(s, d, r, b)
                    else
                      fzn_cumulative_time(s, d, r, b)
                    endif
                )
            endif
            ;


predicate fzn_cumulative_time(array[int] of var int: s,
                     array[int] of var int: d,
                     array[int] of var int: r, var int: b) =
    let { 
        set of int: Tasks = 
            {i | i in index_set(s) where ub(r[i]) > 0 /\ ub(d[i]) > 0 },
        int: early = min([ lb(s[i]) | i in Tasks ]), 
        int: late  = max([ ub(s[i]) + ub(d[i]) | i in Tasks ]) 
    } in (
        forall( t in early..late ) (
            if is_fixed(b) /\ is_fixed([r[i] | i in Tasks]) then
              pb_le_weighted([s[i] <= t /\ t < s[i] + d[i] | i in Tasks], [fix(r[i]) | i in Tasks], fix(b))
            else
              b >= sum( i in Tasks ) (
                  bool2int(s[i] <= t /\ t < s[i] + d[i]) * r[i]
              )
            endif
        )
    );

predicate fzn_cumulative_task(array[int] of var int: s,
                     array[int] of var int: d,
                     array[int] of var int: r, var int: b) =
    let { 
        set of int: Tasks = 
            {i | i in index_set(s) where ub(r[i]) > 0 /\ ub(d[i]) > 0 }
    } in (
        forall( j in Tasks ) ( 
            if is_fixed(b) /\ is_fixed([r[i] | i in Tasks]) /\ is_fixed(r[j]) then
              pb_le_weighted([s[i] <= s[j] /\ s[j] < s[i] + d[i] | i in Tasks where i != j], [fix(r[i]) | i in Tasks where i != j], fix(b)-fix(r[j]))
            else
              b >= r[j] + sum( i in Tasks where i != j ) ( 
                  bool2int(s[i] <= s[j] /\ s[j] < s[i] + d[i] ) * r[i]
              )
            endif
        )
    );

