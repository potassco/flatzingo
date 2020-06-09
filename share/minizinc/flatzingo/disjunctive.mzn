predicate disjunctive(array [int] of var opt int: s,
                      array [int] of var int: d) =
    assert(index_set(s) == index_set(d),
        "disjunctive: the array arguments must have identical index sets",
    if is_fixed(d) then
        flatzingo_fixed_disjunctive(s, fix(d))
    else
        fzn_disjunctive(s, d)
    endif;

