predicate fzn_bin_packing_capa(array[int] of int: c,
                           array[int] of var int: bin,
                           array[int] of int: w) =
      forall( i in index_set(bin) ) (
            min(index_set(c)) <= bin[i] /\ bin[i] <= max(index_set(c))
      )
    /\
      forall( b in index_set(c) ) (
            pb_le_weighted([bin[i] = b | i in index_set(bin)], [w[i] | i in index_set(bin)], c[b])
      );

%-----------------------------------------------------------------------------%
