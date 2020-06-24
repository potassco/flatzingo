import argparse
from subprocess import *
import sys

def main():
    parser = argparse.ArgumentParser(description='Solve CP Problems using clingcon.')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-a', dest='solutions', default=1, action='store_const', const=0, 
                       help='Compute all solutions.')
    group.add_argument('-n', dest='solutions', default=1, type=int,
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
    with Popen(["fzn2lp", args.flatzinc], stdout=PIPE) as fzn2lp:
        with Popen(["clingcon", "encoding.lp", "-"], stdin=fzn2lp.stdout, bufsize=1, universal_newlines=True, stdout=PIPE) as clingcon:
            for line in clingcon.stdout:
                print(line, end='')
                sys.stdout.flush()

if __name__ == "__main__":
    main()


