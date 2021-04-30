from run import check

def test_mzn():
    check("tests/mzn/int_abs_1.mzn", [["x=-2", "y=2"], ["x=-1", "y=1"], ["x=0", "y=0"], ["x=1", "y=1"], ["y=2", "x=2"]])
