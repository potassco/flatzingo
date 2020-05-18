# :flamingo: flatzingo

A flatzinc frontend for clingcon 

Basically the following pipeline:

``` sh
cat example.mzn | minizinc -c --solver org.minizinc.mzn-fzn | fzn2lp | clingcon encoding.lp
```
