# :flamingo: flatzingo

A flatzinc frontend for clingcon

Basically the following pipeline:

For checking of unsupported constraints,
``` sh
{minizinc -c --solver org.minizinc.mzn-fzn --output-fzn-to-stdout example.mzn | fzn2lp; cat static_check.lp }| clingcon
```

computing a solution,
``` sh
{minizinc -c --solver org.minizinc.mzn-fzn --output-fzn-to-stdout example.mzn | fzn2lp; cat encoding.lp }| clingcon
```
