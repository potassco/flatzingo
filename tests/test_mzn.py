from run import check
import itertools

def test_mzn():
    check("tests/mzn/int_abs_1.mzn", [["x=-2", "y=2"], ["x=-1", "y=1"], ["x=0", "y=0"], ["x=1", "y=1"], ["y=2", "x=2"]])
    check("tests/mzn/all_different_1.mzn", [[f"x={x}", f"y={y}", f"z={z}"] for x,y,z in itertools.product(range(6), range(6), range(8)) if x!=y and x!=z and y!=z ])
