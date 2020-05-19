# :flamingo: flatzingo

A flatzinc frontend for clingcon

Basically the following pipeline:

``` sh
{minizinc -c --solver org.minizinc.mzn-fzn --output-fzn-to-stdout example.mzn | fzn2lp; cat encoding.lp }| clingcon
```
