#!/bin/bash

declare -i num_failed=0
declare -i num_passed=0

for testfile in `find tests/ -maxdepth 1 -type f -name '*.py'`; do
  echo === testing $testfile using built-in-to-test-runner regex that probably matches _all_ installed Python interpreters ===
  DEBUG=99 ./bin/terry 'python([2-9](\.[[:digit:]])?)?' "$testfile"
  if [ 0 -eq $? ]; then
    num_passed+=1
  else
    echo -e "\033[1;31m$testfile failed.\033[0m"
    num_failed+=1
  fi
  echo
done

echo

if find / -maxdepth 1 -perm /0 >/dev/null 2>/dev/null; then
  PERM111='-perm /111' # the new way
else
  PERM111='-perm +111' # the old way
fi


if which terry >/dev/null 2>/dev/null; then
  for testfile in `find tests/ -maxdepth 1 -type f -name '*.py' $PERM111`; do
    echo "====== testing $testfile using its shebang line [making the assumption it has one, since it is executable] ======"
    DEBUG=99 "$testfile"
    if [ 0 -eq $? ]; then
      num_passed+=1
    else
      echo -e "\033[1;31m$testfile failed.\033[0m"
      num_failed+=1
    fi
    echo
  done
fi

if [ 0 -eq $num_failed ]; then
  echo "All ($num_passed) tests passed."
else
  echo "$num_passed tests passed, $num_failed failed."
fi
