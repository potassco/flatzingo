import os
from clingo import Control
from clingo.ast import parse_files, ProgramBuilder
from clingcon import ClingconTheory

def mzn2lp(filein, fileout):
    os.system(f'minizinc -O0 -c --solver flatzingo --output-to-stdout {filein} > __temp.fzn')
    os.system(f'fzn2lp __temp.fzn > {fileout}')

def sols(instance, compare):
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

    compare = [set(c) for c in compare]

    assert len(models) == len(compare)
    for c in compare:
        found = False
        for m in models:
            if c.issubset(m):
                found=True
        assert found == True

def check(mzn, solutions):
    mzn2lp(mzn,"__temp.lp")
    sols("__temp.lp", solutions)
