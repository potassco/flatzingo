import os
from operator import eq
from clingo import Control
from clingo.ast import parse_files, ProgramBuilder
from clingcon import ClingconTheory

def mzn2lp(filein, fileout, optstr=0):
    os.system(f'minizinc -O{optstr} -c --solver flatzingo --output-to-stdout {filein} > __temp.fzn')
    os.system(f'fzn2lp __temp.fzn > {fileout}')

def sols(instance, compare, comp):
    files = [os.path.join("encodings","encoding.lp"), os.path.join("encodings","types.lp"), instance]
    thy = ClingconTheory()
    ctl = Control(['0'])
    thy.register(ctl)
    with ProgramBuilder(ctl) as bld:
        parse_files(files, lambda ast: thy.rewrite_ast(ast, bld.add))

    ctl.ground([('base', [])])
    thy.prepare(ctl)
    models = []
    with ctl.solve(yield_=True, on_model=thy.on_model) as hnd:
        for mdl in hnd:
            model = [str(a) for a in mdl.symbols(shown=True)]
            model += ["{}={}".format(str(key).strip('"'), val) for key, val in thy.assignment(mdl.thread_id)]
            models.append(set(model))

    bool_herbrand = set([i for sl in compare for i in sl if i.startswith("var(")])

    compare = [set(c) for c in compare]

    assert comp(len(models), len(compare)), f"{models}\n vs {compare}\ncomputed {len(models)} expected {len(compare)}"
    for c in compare:
        # for all in herbrand which are not in compare -> ensure that they are not in model
        found = False
        for m in models:
            if c.issubset(m):
                if ((bool_herbrand - c) & m) == set():
                    found=True
                    break
        assert found == True, f"{c} not in {models}"


def check(mzn, solutions, optstr=0, comp = eq):
    mzn2lp(mzn,"__temp.lp", optstr)
    sols("__temp.lp", solutions, comp)
