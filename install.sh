#!/bin/bash
mkdir -p ~/.minizinc/solvers
mkdir -p ~/.minizinc/share
cp configuration/flatzingo.msc ~/.minizinc/solvers/
cp -r share/minizinc/flatzingo ~/.minizinc/share/
