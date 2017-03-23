#!/bin/bash
echo "REMOVE PREVIOUS BUILD"
rm -rf build

echo "BUILDING"
mkdir build
g++ -Wall -o build/BiggestUnInt src/BiggestUnInt.cc
g++ -Wall -o build/HelloWorld src/HelloWorld.cpp
g++ -Wall -o build/SimpleClass src/SimpleClass.cc
RC=$?

if [ $RC -ne 0 ]; then
  echo "BUILD FAILURE"
else
  echo "BUILD SUCCESS"
fi
