from run import check
import itertools
import math

def test_mzn():
    check("tests/mzn/all_different_1.mzn", [[f"x={x}", f"y={y}", f"z={z}"] for x,y,z in itertools.product(range(6), range(6), range(8)) if x!=y and x!=z and y!=z ])
    check("tests/mzn/array_int_element_1.mzn", [[f"b={b+1}", f"c={c}"] for b,a,c in itertools.product(range(0,5), [[1,2,4,6,12]], range(0,14)) if a[b] == c ])
    check("tests/mzn/array_int_maximum_1.mzn", [[f"a={a}", f"b={b}", f"c={c}", f"d={d}", f"m={m}"] for a,b,c,d,m in itertools.product(range(0,5), range(0,14), range(-5,3), range(-8,-2), range(0,17) ) if max(a,b,c,d) == m ])
    check("tests/mzn/array_int_minimum_1.mzn", [[f"a={a}", f"b={b}", f"c={c}", f"d={d}", f"m={m}"] for a,b,c,d,m in itertools.product(range(0,5), range(0,14), range(-5,3), range(-8,-2), range(-10,7) ) if min(a,b,c,d) == m ])
    check("tests/mzn/array_var_int_element_1.mzn", [[f"b={b+1}", f"a1={list(a)[0]}", f"a2={list(a)[1]}", f"a3={list(a)[2]}", f"a4={list(a)[3]}", f"a5={list(a)[4]}", f"c={c}"] for b,c in itertools.product(range(0,5), range(-5,14)) for a in itertools.product(range(0,6), range(-3,4), range(-1,7), range(3,6), range(3,6)) if list(a)[b] == c ])
    check("tests/mzn/int_abs_1.mzn", [["x=-2", "y=2"], ["x=-1", "y=1"], ["x=0", "y=0"], ["x=1", "y=1"], ["y=2", "x=2"]])
   #revisit to maybe avoid symmetries ?
    check("tests/mzn/int_div_1.mzn", [[f"a={a}", f"b={b}", f"c={c}"] for a,b,c in itertools.product(range(-3,10), itertools.chain(range(-5,0), range(1,6)), range(8)) if (a*b>0 and a//b == c) or ( a*b<=0 and (a+(-a%b))//b == c)], lambda a,b: (a > b))
    check("tests/mzn/int_eq_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if a == b])
    check("tests/mzn/int_eq_reif_1.mzn", [[f"a={a}", f"b={b}"] + (['var("r")'] if r else []) for a,b,r in itertools.product(range(-3,10), range(-5,6), [False, True]) if (r and a == b) or (not r and a != b)])
    check("tests/mzn/int_le_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if a <= b])
    check("tests/mzn/int_le_reif_1.mzn", [[f"a={a}", f"b={b}"] + (['var("r")'] if r else []) for a,b,r in itertools.product(range(-3,10), range(-5,6), [False, True]) if (r and a <= b) or (not r and a > b)])
    check("tests/mzn/int_lin_eq_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if (3*a + 2*b) == 26])
    check("tests/mzn/int_lin_eq_reif_1.mzn", [[f"a={a}", f"b={b}"] + (['var("r")'] if r else []) for a,b,r in itertools.product(range(-3,10), range(-5,6), [False, True]) if (r and (3*a + 2*b) == 26) or (not r and (3*a + 2*b) != 26)])
