#!/bin/sh

###    This file is part of DBP, a real-time, probabilistic rewriting logic 
###    specification of distance-bounding protocols, facilitating statistical
###    model checking of various guessing and timing attacks and 
###    countermeasures.
###
###    Copyright (C) 2017-2018 Musab A. Alturki, musab.alturki@gmail.com
###
###    This program is free software: you can redistribute it and/or modify
###    it under the terms of the GNU General Public License as published by
###    the Free Software Foundation, either version 3 of the License, or
###    (at your option) any later version.
###
###    This program is distributed in the hope that it will be useful,
###    but WITHOUT ANY WARRANTY; without even the implied warranty of
###    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
###    GNU General Public License for more details.
###
###    You should have received a copy of the GNU General Public License
###    along with this program.  If not, see <http://www.gnu.org/licenses/>.
###
###
###    run-client.sh: Runs the verification tasks
###
###    Usage example:
###        ./run-client 2 model.maude formula.quatex
###

###
### You will probably want to configure the following based on your environment
###

### Set the location of the PVeStA Server jar file here
export PVESTA_BIN="../../binaries"

### Set the filename prefix where the servers are to be found
export SL_FILE_PRE="portlist"

### You can specify how many times the same verification task is repeated
export TRIALS=1


###
# Checks whether the number of servers is supplied as an argument
if [ -z "${1}" ] 
    then 
    echo "Missing number of servers to use."
    echo "Usage: run-client.sh <N> <maude_model_file> <quatex_formula_file>"
else if [ -z "${2}" ] 
    then 
    echo "Missing Maude model file."
    echo "Usage: run-client.sh <N> <maude_model_file> <quatex_formula_file>"
else if [ -z "${3}" ] 
    then 
    echo "Missing QuaTEx formula file."
    echo "Usage: run-client.sh <N> <maude_model_file> <quatex_formula_file>"
else
    trials=$TRIALS
    for (( c = 1; c <= $trials; c++ ))
      do
      echo "##### Running trial $c..."
      java -jar $PVESTA_BIN/pvesta-client.jar -l $SL_FILE_PRE${1} -m $2 -f $3 -a 0.01 -d1 0.01
      sleep 1
      rm _*
    done
fi fi fi
