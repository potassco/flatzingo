import argparse
from subprocess import *
import sys
import os


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

    clingcon_command = [os.path.join(sys.path[0],"clingcon"), "encoding.lp", "-"]
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

    with Popen([os.path.join(sys.path[0],"fzn2lp"), args.flatzinc], stdout=PIPE) as fzn2lp:
        with Popen(clingcon_command, stdin=fzn2lp.stdout, bufsize=1, universal_newlines=True, stdout=PIPE) as clingcon:
            answer = False
            assignment = False
            complete = False
            for line in clingcon.stdout:
                if answer:
                    # also check for bool output vars
                    answer = False
                elif assignment:
                    # TODO: for array output annotations we need the annotations and we need to parse the solution and reconvert it
                    assignment = False
                    print("----------")
                    sys.stdout.flush()
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
                print(line, end='') # debug
                sys.stdout.flush()
            if complete:
                print("==========")
                sys.stdout.flush()

if __name__ == "__main__":
    main()


