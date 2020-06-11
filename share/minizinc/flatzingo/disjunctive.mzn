include "disjunctive_strict.mzn";
include "fzn_disjunctive.mzn";

predicate disjunctive(array [int] of var int: s,
                      array [int] of var int: d) =
    assert(index_set(s) == index_set(d),
        "disjunctive: the array arguments must have identical index sets",
        if is_fixed(d) then
            flatzingo_fixed_disjunctive(s, fix(d))
        else
            if (lb_array(d) > 0) then
              disjunctive_strict(s,d)
            else
              fzn_disjunctive(s,d)
            endif
        endif
        );

predicate flatzingo_fixed_disjunctive(array [int] of var int: s,
                                      array [int] of int: d);
