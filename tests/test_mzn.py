from run import check
import itertools
import math
import operator

def toBool(*arg):
  ret = []
  for i in range(0,len(arg),2):
    if arg[i]:
        ret.append(f'var("{arg[i+1]}")')
  return ret

BOOL = [False, True]

def test_mzn_slow():
    check("tests/mzn/array_var_int_element_1.mzn", [[f"b={b+1}", f"a1={list(a)[0]}", f"a2={list(a)[1]}", f"a3={list(a)[2]}", f"a4={list(a)[3]}", f"a5={list(a)[4]}", f"c={c}"] for b,c in itertools.product(range(0,5), range(-5,14)) for a in itertools.product(range(0,6), range(-3,4), range(-1,7), range(3,6), range(3,6)) if list(a)[b] == c ])

def test_mzn_fast():
    ### integer builtins

    check("tests/mzn/all_different_1.mzn", [[f"x={x}", f"y={y}", f"z={z}"] for x,y,z in itertools.product(range(6), range(6), range(8)) if x!=y and x!=z and y!=z ])
    check("tests/mzn/array_int_element_1.mzn", [[f"b={b+1}", f"c={c}"] for b,a,c in itertools.product(range(0,5), [[1,2,4,6,12]], range(0,14)) if a[b] == c ])
    check("tests/mzn/array_int_maximum_1.mzn", [[f"a={a}", f"b={b}", f"c={c}", f"d={d}", f"m={m}"] for a,b,c,d,m in itertools.product(range(0,5), range(0,14), range(-5,3), range(-8,-2), range(0,17) ) if max(a,b,c,d) == m ])
    check("tests/mzn/array_int_minimum_1.mzn", [[f"a={a}", f"b={b}", f"c={c}", f"d={d}", f"m={m}"] for a,b,c,d,m in itertools.product(range(0,5), range(0,14), range(-5,3), range(-8,-2), range(-10,7) ) if min(a,b,c,d) == m ])
    check("tests/mzn/int_abs_1.mzn", [["x=-2", "y=2"], ["x=-1", "y=1"], ["x=0", "y=0"], ["x=1", "y=1"], ["y=2", "x=2"]])
    #revisit to maybe avoid symmetries ?
    check("tests/mzn/int_div_1.mzn", [[f"a={a}", f"b={b}", f"c={c}"] for a,b,c in itertools.product(range(-3,10), itertools.chain(range(-5,0), range(1,6)), range(8)) if (a*b>0 and a//b == c) or ( a*b<=0 and (a+(-a%b))//b == c)], comp = operator.ge)
    check("tests/mzn/int_eq_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if a == b])
    check("tests/mzn/int_eq_reif_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a == b) or (not r and a != b)])
    check("tests/mzn/int_eq_imp_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a == b) or (not r)])
    check("tests/mzn/int_le_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if a <= b])
    check("tests/mzn/int_le_reif_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a <= b) or (not r and a > b)])
    check("tests/mzn/int_le_imp_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a <= b) or (not r)])
    check("tests/mzn/int_lin_eq_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if (3*a + 2*b) == 26])
    check("tests/mzn/int_lin_eq_reif_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and (3*a + 2*b) == 26) or (not r and (3*a + 2*b) != 26)])
    check("tests/mzn/int_lin_eq_imp_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and (3*a + 2*b) == 26) or (not r)], optstr=2)
    check("tests/mzn/int_lin_le_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if (3*a + 2*b) <= 26])
    check("tests/mzn/int_lin_le_reif_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and (3*a + 2*b) <= 26) or (not r and (3*a + 2*b) > 26)])
    check("tests/mzn/int_lin_le_imp_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and (3*a + 2*b) <= 26) or (not r)])
    check("tests/mzn/int_lin_ne_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if (3*a + 2*b) != 26])
    check("tests/mzn/int_lin_ne_reif_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and (3*a + 2*b) != 26) or (not r and (3*a + 2*b) == 26)])
    check("tests/mzn/int_lin_ne_imp_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and (3*a + 2*b) != 26) or (not r)])
    check("tests/mzn/int_lt_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if a < b])
    check("tests/mzn/int_lt_reif_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a < b) or (not r and a >= b)])
    check("tests/mzn/int_lt_imp_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a < b) or (not r)])
    check("tests/mzn/int_max_1.mzn", [[f"a={a}", f"b={b}", f"c={c}"] for a,b,c in itertools.product(range(-3,10), range(-5,6), range(8)) if c == max(a,b)])
    check("tests/mzn/int_min_1.mzn", [[f"a={a}", f"b={b}", f"c={c}"] for a,b,c in itertools.product(range(-3,10), range(-5,6), range(8)) if c == min(a,b)])
    #revisit to maybe avoid symmetries ?
    check("tests/mzn/int_mod_1.mzn", [[f"a={a}", f"b={b}", f"c={c}"] for a,b,c in itertools.product(range(-3,10), itertools.chain(range(-5,0), range(1,6)), range(8)) if (a*b>0 and a%b == c) or ( a*b<=0 and (-a%b) == -c)], comp = operator.ge)
    check("tests/mzn/int_ne_1.mzn", [[f"a={a}", f"b={b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if a != b])
    check("tests/mzn/int_ne_reif_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a != b) or (not r and a == b)])
    check("tests/mzn/int_ne_imp_1.mzn", [[f"a={a}", f"b={b}"] + toBool(r,"r") for a,b,r in itertools.product(range(-3,10), range(-5,6), BOOL) if (r and a != b) or (not r)])
    check("tests/mzn/int_plus_1.mzn", [[f"a={a}", f"b={b}", f"c={c}"] for a,b,c in itertools.product(range(-3,10), range(-5,6), range(-10,11)) if a+b==c])
    check("tests/mzn/int_pow_1.mzn", [[f"a={a}", f"b={b}", f"c={pow(a,b)}"] for a,b in itertools.product(range(1,10), range(0,6)) if 0 <= pow(a,b) <=100])
    check("tests/mzn/int_times_1.mzn", [[f"a={a}", f"b={b}", f"c={a*b}"] for a,b in itertools.product(range(-3,10), range(-5,6)) if -100 <= a*b <=100])
    check("tests/mzn/set_in_1.mzn", [[f"a={a}"] for a in range(-10,131) if a in [-4,3,4,5,123]])
    check("tests/mzn/set_in_reif_1.mzn", [[f"a={a}"] + toBool(r,"r") for a,r in itertools.product(range(-10,131), BOOL) if (r and a in [-4,3,4,5,123]) or (not r and a not in [-4,3,4,5,123])])
    check("tests/mzn/set_in_imp_1.mzn", [[f"a={a}"] + toBool(r,"r") for a,r in itertools.product(range(-10,131), BOOL) if (r and a in [-4,3,4,5,123]) or (not r)], optstr=2)


    ### boolean builtins

    # no reif or imp possible, minizinc bug ?
    check("tests/mzn/array_bool_and_1.mzn", [toBool(a1,"a1",a2,"a2",a3,"a3",r,"r") for a1,a2,a3,r in itertools.product(BOOL, BOOL, BOOL, BOOL) if (r and (a1 and a2 and a3)) or (not r and not (a1 and a2 and a3))])
    # no reif or imp needed
    check("tests/mzn/array_bool_element_1.mzn", [[f"b={b}"] + toBool(c,"c") for b,c in itertools.product(range(1,10), BOOL) if (c and b in [1,2,4,5,8,9]) or (not c and b not in [1,2,4,5,8,9])])
    # no reif or imp possible, minizinc bug ?
    check("tests/mzn/array_bool_or_1.mzn", [toBool(a1,"a1",a2,"a2",a3,"a3",r,"r") for a1,a2,a3,r in itertools.product(BOOL, BOOL, BOOL, BOOL) if (r and (a1 or a2 or a3)) or (not r and not (a1 or a2 or a3))])
    # no reif or imp possible, minizinc bug ?
    check("tests/mzn/array_bool_xor_1.mzn", [toBool(a1,"a1",a2,"a2",a3,"a3",a4,"a4") for a1,a2,a3,a4 in itertools.product(BOOL, BOOL, BOOL, BOOL) if (a1 ^ a2 ^ a3 ^ a4) ])
    # no reif or imp needed, translation is ok
    check("tests/mzn/array_var_bool_element_1.mzn", [[f"b={b}"] + toBool(a1,"a1",a2,"a2",a3,"a3",a4,"a4",a5,"a5",a6,"a6",a7,"a7",a8,"a8",a9,"a9",c,"c") for b,a1,a2,a3,a4,a5,a6,a7,a8,a9,c in itertools.product(range(1,10), BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL) if eval(f'a{b}')==c ])
    # this only works for -O0 currently, minizinc bug
    check("tests/mzn/bool2int_1.mzn", [[f"b={b}"] + toBool(c,"c") for b,c in itertools.product(range(0,10), BOOL) if (c and b == 1) or (not c and b == 0)])
    # no reif or imp possible, minizinc bug ?
    check("tests/mzn/bool_and_1.mzn", [toBool(a,"a",b,"b",r,"r") for a,b,r in itertools.product(BOOL, BOOL, BOOL) if (r and (a and b) or (not r and not (a and b)))])
    check("tests/mzn/bool_clause_1.mzn", [toBool(a1,"a1",a2,"a2",a3,"a3",a4,"a4",a5,"a5",a6,"a6",a7,"a7",a8,"a8",a9,"a9") for a1,a2,a3,a4,a5,a6,a7,a8,a9 in itertools.product(BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL) if a1 or a2 or a3 or a4 or not a5 or not a6 or not a7 or not a8 or not a9 ])
    check("tests/mzn/bool_clause_reif_1.mzn", [toBool(a1,"a1",a2,"a2",a3,"a3",a4,"a4",a5,"a5",a6,"a6",a7,"a7",a8,"a8",a9,"a9",r,"r") for a1,a2,a3,a4,a5,a6,a7,a8,a9,r in itertools.product(BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL) if r and (a1 or a2 or a3 or a4 or not a5 or not a6 or not a7 or not a8 or not a9) or (not r and not (a1 or a2 or a3 or a4 or not a5 or not a6 or not a7 or not a8 or not a9)) ])
    # does not exist ?
    check("tests/mzn/bool_clause_imp_1.mzn", [toBool(a1,"a1",a2,"a2",a3,"a3",a4,"a4",a5,"a5",a6,"a6",a7,"a7",a8,"a8",a9,"a9",r,"r") for a1,a2,a3,a4,a5,a6,a7,a8,a9,r in itertools.product(BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL) if r and (a1 or a2 or a3 or a4 or not a5 or not a6 or not a7 or not a8 or not a9) or (not r) ])
    check("tests/mzn/bool_eq_1.mzn", [toBool(a,"a",b,"b") for a,b in itertools.product(BOOL, BOOL) if (a == b)])
    check("tests/mzn/bool_eq_reif_1.mzn", [toBool(a,"a",b,"b",r,"r") for a,b,r in itertools.product(BOOL, BOOL, BOOL) if (r and (a == b) or (not r and not (a == b)))])
    check("tests/mzn/bool_eq_imp_1.mzn", [toBool(a,"a",b,"b",r,"r") for a,b,r in itertools.product(BOOL, BOOL, BOOL) if (r and (a == b) or (not r))], optstr=2)

    check("tests/mzn/bool_le_1.mzn", [toBool(a,"a",b,"b") for a,b in itertools.product(BOOL, BOOL) if (a <= b)])
    check("tests/mzn/bool_le_reif_1.mzn", [toBool(a,"a",b,"b",r,"r") for a,b,r in itertools.product(BOOL, BOOL, BOOL) if (r and (a <= b) or (not r and not (a <= b)))])
    check("tests/mzn/bool_le_imp_1.mzn", [toBool(a,"a",b,"b",r,"r") for a,b,r in itertools.product(BOOL, BOOL, BOOL) if (r and (a <= b) or (not r))], optstr=2)

    check("tests/mzn/bool_lt_1.mzn", [toBool(a,"a",b,"b") for a,b in itertools.product(BOOL, BOOL) if (a < b)])
    check("tests/mzn/bool_lt_reif_1.mzn", [toBool(a,"a",b,"b",r,"r") for a,b,r in itertools.product(BOOL, BOOL, BOOL) if (r and (a < b) or (not r and not (a < b)))])
    check("tests/mzn/bool_lt_imp_1.mzn", [toBool(a,"a",b,"b",r,"r") for a,b,r in itertools.product(BOOL, BOOL, BOOL) if (r and (a < b) or (not r))], optstr=2)
