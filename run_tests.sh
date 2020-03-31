#!/bin/bash

declare -i num_failed=0
declare -i num_passed=0

for testfile in `find tests/ -maxdepth 1 -type f`; do
  echo === $testfile ===
  DEBUG=99 ./bin/terry 'python([2-9](\.[[:digit:]])?)?' "$testfile"
  if [ 0 -eq $? ]; then
    num_passed+=1
  else
    num_failed+=1
  fi
  echo
done

echo

if [ 0 -eq $num_failed ]; then
  echo "All ($num_passed) tests passed."
else
  echo "$num_passed tests passed, $num_failed failed."
fi
