#!/bin/bash
echo "REMOVE PREVIOUS BUILD"
rm -rf build

echo "BUILDING"
mkdir build
g++ -c -Wall -o build/BiggestUnInt src/BiggestUnInt.cc
g++ -c -Wall -o build/HelloWorld src/HelloWorld.cpp
g++ -c -Wall -o build/SimpleClass src/SimpleClass.cc
RC=$?

if [ $RC -ne 0 ]; then
  echo "BUILD FAILURE"
else
  echo "BUILD SUCCESS"
fi
