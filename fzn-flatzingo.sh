#!/bin/bash

# Absolute path to this script. /home/user/bin/foo.sh
DIR="$( cd "$( dirname "$0" )" && pwd )"
python3 $DIR/fzn-flatzingo.py "$@"