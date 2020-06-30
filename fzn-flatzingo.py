import argparse
from subprocess import *
import sys
import os
import re

class Solution:
    def __init__(self):
        self.clear()
        self.array_comp = re.compile("variable_value\((.*),array,\((.*),var,(.*)\)\)")

    def clear(self):
        self.atoms  = set()
        self.output_vars = []
        self.output_array_dim = {}
        self.output_array = {} # array name to content map ID->name
        self.variables = {}

    def readAnswer(self, line):
        self.clear()
        for word in line.split(' '):
            if word.startswith("output_var"):
                self.output_vars.append(word[len("output_var("):-1])
            elif word.startswith("output_array_dim"):
                word = word[len("output_array_dim("):-1]
                t = word.rpartition(',')
                self.output_array_dim[t[0]] = t[2]
            else:
                x = self.array_comp.match(word)
                if x is not None:
                    self.output_array.setdefault(x.group(1),{})[x.group(2)] = x.group(3)
                else:              
                    self.atoms.add(word)
    
    def readAssignment(self, line):
        for word in line.split(' '):
            t = word.rpartition('=')
            self.variables[t[0]] = t[2]

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
                raise Exception("Output array not defined")
            x = [var for (index,var) in sorted(self.output_array[array].items())]
            for var in x:
                if var not in self.variables:
                    raise Exception("Output variable {} not found".format(var))
            x = [self.variables[var] for var in x]
            print("{} = array{}d({});".format(array.strip('"'),dim,",".join(x)))
            
        print("----------")
        sys.stdout.flush()

def main():
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
    args = parser.parse_args()
    
    optimization = False
    with open(args.flatzinc) as inputfile:
        for line in inputfile:
            if "maximize" in line or "minimize" in line:
                optimization = True
    if args.n is not None and optimization:
        raise Exception("Option -n is not allowed on optimization problems")

    #clingcon_command = [os.path.join(sys.path[0],"clingcon"), "encoding.lp", "-"]
    clingcon_command = ["clingcon", os.path.join(sys.path[0],"encoding.lp"), "-"]
    num_models = 1
    if args.a:
        num_models = 0
    if optimization:
        num_models = 0
    if args.n is not None:
        num_models = args.n
    clingcon_command.append(str(num_models))
    if args.s:
        clingcon_command.append("--stats=2")
    if args.p is not None:
        clingcon_command.append("-t{}".format(args.p))
    if args.r is not None:
        clingcon_command.append("--seed={}".format(args.r))
    if args.t is not None:
        clingcon_command.append("--time={}".format(args.t/1000))

    #with Popen([os.path.join(sys.path[0],"fzn2lp"), args.flatzinc], stdout=PIPE) as fzn2lp:
    with Popen(["fzn2lp", args.flatzinc], stdout=PIPE) as fzn2lp:
        with Popen(clingcon_command, stdin=fzn2lp.stdout, bufsize=1, universal_newlines=True, stdout=PIPE) as clingcon:
            answer = False
            assignment = False
            complete = False
            sol = Solution()
            for line in clingcon.stdout:
                if answer:
                    # also check for bool output vars
                    sol.readAnswer(line)
                    answer = False
                elif assignment:
                    # TODO: for array output annotations we need the annotations and we need to parse the solution and reconvert it
                    sol.readAssignment(line)
                    assignment = False
                    sol.printSolution()
                elif "UNSATISFIABLE" in line:
                    print("=====UNSATISFIABLE=====")
                    sys.stdout.flush()
                elif "Models" in line:
                    if not line.endswith("+"):
                        complete = True
                elif "Answer:" in line:
                    answer = True
                elif "Assignment:" in line:
                    assignment = True
                #print(line, end='') # debug
                #sys.stdout.flush()
            if complete:
                print("==========")
                sys.stdout.flush()

if __name__ == "__main__":
    main()


