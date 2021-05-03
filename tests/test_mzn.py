from run import check
import itertools

def test_mzn():
    check("tests/mzn/int_abs_1.mzn", [["x=-2", "y=2"], ["x=-1", "y=1"], ["x=0", "y=0"], ["x=1", "y=1"], ["y=2", "x=2"]])
    check("tests/mzn/all_different_1.mzn", [[f"x={x}", f"y={y}", f"z={z}"] for x,y,z in itertools.product(range(6), range(6), range(8)) if x!=y and x!=z and y!=z ])
    check("tests/mzn/array_int_element_1.mzn", [[f"b={b+1}", f"c={c}"] for b,a,c in itertools.product(range(0,5), [[1,2,4,6,12]], range(0,14)) if a[b] == c ])
    check("tests/mzn/array_int_maximum_1.mzn", [[f"a={a}", f"b={b}", f"c={c}", f"d={d}", f"m={m}"] for a,b,c,d,m in itertools.product(range(0,5), range(0,14), range(-5,3), range(-8,-2), range(0,17) ) if max(a,b,c,d) == m ])
    check("tests/mzn/array_int_minimum_1.mzn", [[f"a={a}", f"b={b}", f"c={c}", f"d={d}", f"m={m}"] for a,b,c,d,m in itertools.product(range(0,5), range(0,14), range(-5,3), range(-8,-2), range(-10,7) ) if min(a,b,c,d) == m ])
