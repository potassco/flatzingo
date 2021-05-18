import argparse
from subprocess import *
import sys
import os
import re
import tempfile

optimization = False

stats = {}
stats["time"]            = re.compile("^Time\s*:\s(.*)s \(.*")
stats["choices"]         = re.compile("^Choices\s*:\s(.*)$")
stats["conflicts"]       = re.compile("^Conflicts\s*:\s(\d+).*")
stats["rules"]           = re.compile("^Rules\s*:\s(.*)$")
stats["boolVariables"]   = re.compile("^Variables\s*:\s(\d+).*")
stats["nogoods"]         = re.compile("^Constraints\s*:\s(\d+).*")

stats["init_total"]      = re.compile("^\s{4}Total\s*:\s(.*)$")
stats["init_simplify"]   = re.compile("^\s{4}Simplify\s*:\s(.*)$")
stats["init_translate"]  = re.compile("^\s{4}Translate\s*:\s(.*)$")

stats["csp_constraints"] = re.compile("^\s{4}Constraints\s*:\s(.*)$")
stats["intVariables"]    = re.compile("^\s{4}Variables\s*:\s(.*)$")
stats["csp_clauses"]     = re.compile("^\s{4}Clauses\s*:\s(.*)$")
stats["csp_literals"]    = re.compile("^\s{4}Literals\s*:\s(.*)$")

stats["csp_time_total"] = re.compile("^\s{6}Time\s*:\s(.*)$")
stats["csp_time_propagation"] = re.compile("^\s{6}Propagation\s*:\s(.*)$")
stats["csp_time_check"] = re.compile("^\s{6}Check\s*:\s(.*)$")
stats["csp_time_undo"] = re.compile("^\s{6}Undo\s*:\s(.*)$")

stats["csp_refined_reason"] = re.compile("^\s{4}Refined reason\s*:\s(.*)$")
stats["csp_introduced_reason"] = re.compile("^\s{4}Introduced reason\s*:\s(.*)$")
stats["csp_literals_introduced"] = re.compile("^\s{4}Literals introduced\s*:\s(.*)$")

stats["objective"] = re.compile("(?:^Cost:\s*(.*)$|^Optimization:\s*(.*)$)")

def check_constant(s):
    s = str(s)
    if s == "true" or s == "false":
        return True
    if s[0] in ('-', '+'):
        return s[1:].isdigit()
    return s.isdigit()

def readStat(line):
    for (name,r) in stats.items():
        x = r.match(line)
        if x is not None:
            if x.group(1) is not None:
                print("%%%mzn-stat: {}={}".format(name,x.group(1)))
            elif x.group(2) is not None:
                print("%%%mzn-stat: {}={}".format(name,x.group(2)))
            if optimization and name=="objective":
                print("----------")

class Solution:
    def __init__(self):
        self.clear()
        self.array_comp = re.compile("variable_value\((.*),array,\((.*),(?:var|value),(.*)\)\)")
        self.array_dim = re.compile("output_array\((.*),(.*),\((.*),(.*)\)\)")
        self.output_vars = []
        self.output_array_dim = {}
        self.output_array = {} # array name to content map ID->name

    def clear(self):
        self.atoms  = set()
        self.variables = {}

    def readInstance(self, word):
        if word.startswith("output_var"):
            self.output_vars.append(word[len("output_var("):-3])
        elif word.startswith("output_array("):
            x = self.array_dim.match(word)
            if x is not None:
                self.output_array_dim.setdefault(x.group(1),{})[x.group(2)] = "{}..{}".format(x.group(3),x.group(4))
            else:
                raise Exception("Malformed output array")
        else:
            x = self.array_comp.match(word)
            if x is not None:
                self.output_array.setdefault(x.group(1),{})[int(x.group(2))] = x.group(3)


        
    def readAnswer(self, line):
        self.clear()
        for word in line.rstrip().split(' '):
            self.atoms.add(word[4:-1])
    
    def readAssignment(self, line):
        for word in line.split(' '):
            t = word.rpartition('=')
            self.variables[t[0]] = t[2].rstrip()

    def printSolution(self):
        for v in self.output_vars:
            if v in self.variables:
                print("{} = {};".format(v.strip('"'),self.variables[v]))
            elif v in self.atoms:
                print("{} = true;".format(v.strip('"')))
            else:
                print("{} = false;".format(v.strip('"')))
        for (array,dim) in self.output_array_dim.items():
            if array not in self.output_array:
                raise Exception("Output array {} not defined".format(array))
            x = [var for (index,var) in sorted(self.output_array[array].items())]
            x = [self.variables[var] if var in self.variables else (var if check_constant(var) else ("true" if var in self.atoms else "false")) for var in x]
            dimensions = [b for (a,b) in sorted(dim.items())]
            print("{} = array{}d({},{});".format(array.strip('"'),len(dim),",".join(dimensions),"["+",".join(x)+"]"))
            
        if not optimization:
            print("----------")
        sys.stdout.flush()


def main():
    argum = []
    for i in sys.argv:
        if i == "--":
            break
        argum.append(i)
    solverargs = []
    if len(argum) < len(sys.argv):
        solverargs = sys.argv[len(argum)+1:]
    parser = argparse.ArgumentParser(description='Solve CP Problems using clingcon.')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-a', action='store_true', 
                       help='Compute all solutions.')
    group.add_argument('-n', type=int,
                       help='Compute n solutions. 0=all')
    parser.add_argument('-f', action='store_true',
                       help='Enable free search. default: only free search supported.')
    parser.add_argument('-s', action='store_true', default=False,
                       help='Enable statistics.')
    parser.add_argument('-v', action='store_true',
                       help='Enable verbose messages. Does nothing.')
    parser.add_argument('-p', default=1, type=int, metavar='N',
                       help='Run with <N> parallel threads.')
    parser.add_argument('-r', type=int, metavar='R',
                       help='Use ransom seed <R>.')
    parser.add_argument('-t', type=int,
                       help='Walltime in ms.')
    parser.add_argument('flatzinc', 
                       help="Problem file in flatzinc format.")
    parsed = parser.parse_args(argum[1:])
    
    global optimization

    with open(parsed.flatzinc) as inputfile:
        for line in inputfile:
            if "maximize" in line or "minimize" in line:
                optimization = True
    if parsed.n is not None and optimization:
        raise Exception("Option -n is not allowed on optimization problems")

    clingcon_command = ["clingcon", os.path.join(sys.path[0], "encodings", "encoding.lp"), os.path.join(sys.path[0], "encodings", "types.lp")]
    num_models = 1
    if parsed.a:
        num_models = 0
    if optimization:
        num_models = 0
    if parsed.n is not None:
        num_models = parsed.n

    clingcon_command.append(str(num_models))
    if parsed.s:
        clingcon_command.append("--stats=2")
    if parsed.p is not None:
        clingcon_command.append("-t{}".format(parsed.p))
    if parsed.r is not None:
        clingcon_command.append("--seed={}".format(parsed.r))
    if parsed.t is not None:
        clingcon_command.append("--time={}".format(int(parsed.t/1000)))

    clingcon_command += solverargs + ["--fast-exit"]

    with tempfile.TemporaryDirectory() as td:
        tempname = os.path.join(td, 'test')
        with open(tempname, 'wt') as tempf:
            test = run(["fzn2lp", parsed.flatzinc], stdout=tempf)
    
        clingcon_command.append(tempname)
        sol = Solution()
        with open(tempname, mode='r') as tempf:
            for line in tempf:
                sol.readInstance(line)

        with Popen(clingcon_command, bufsize=1, universal_newlines=True, stdout=PIPE) as clingcon:
            answer = False
            assignment = False
            complete = False
            stats = False
            unsat = False
            for line in clingcon.stdout:
                if stats:
                    readStat(line)
                elif answer:
                    # also check for bool output vars
                    sol.readAnswer(line)
                    answer = False
                elif assignment:
                    sol.readAssignment(line)
                    assignment = False
                    sol.printSolution()
                elif "UNSATISFIABLE" in line:
                    unsat = True
                    print("=====UNSATISFIABLE=====")
                    sys.stdout.flush()
                elif "Models" in line:
                    if not line.rstrip().endswith("+"):
                        complete = True
                elif "Answer:" in line:
                    answer = True
                elif "Assignment:" in line:
                    assignment = True
                elif line.startswith("Time"):
                    readStat(line)
                    stats = True
                elif line.startswith("Cost:") or line.startswith("Optimization:"):
                    readStat(line)
            if complete and not unsat:
                print("==========")
                sys.stdout.flush()

if __name__ == "__main__":
    main()


