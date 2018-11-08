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
###    run-servers.sh: Run the desired numner of LOCAL servers
###
###    Usage example:
###        ./run-servers 2
###

###
### You will probably want to configure the following based on your environment
###

### Set the location of the PVeStA Server jar file here
export PVESTA_BIN="../../binaries"

### Set the starting port number 
### (Note: port numbers lower than 1024 are usually reserved)
export PVESTA_PORT="49046"


###
# Checks whether the number of servers is supplied as an argument
if [ -z "${1}" ] 
    then 
    echo "Missing number of servers to run."
    echo "Usage: run-servers.sh N"
else
    PORT=$PVESTA_PORT
    for (( c = 1; c <= ${1}; c++ ))
      do
      OFILE="server_$c.out"
      echo "Running server $c at port $PORT..."
      java -jar $PVESTA_BIN/pvesta-server.jar $PORT > $OFILE &
      PORT=`expr $PORT + 1` 
    done
fi
