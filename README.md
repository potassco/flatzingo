# :flamingo: flatzingo

A flatzinc frontend for clingcon

Basically the following pipeline:

For checking of unsupported constraints,
``` sh
{minizinc -c -G ../../../share/minizinc/flatzingo --output-fzn-to-stdout example.mzn | fzn2lp; cat static_check.lp types.lp }| clingcon
```

computing a solution,
``` sh
{minizinc -c -G ../../../share/minizinc/flatzingo --output-fzn-to-stdout example.mzn | fzn2lp; cat encoding.lp types.lp }| clingcon
```

Create a docker image:

docker build --no-cache -t flatzingo:1.0 - < Dockerfile_Flatzingo

and test it

docker run --rm flatzingo:1.0 solver /minizinc/test.mzn /minizinc/2.dzn
