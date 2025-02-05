#!/usr/bin/env bash

mkdir $GITHUB_WORKSPACE/test_results

source /opt/venv/bin/activate

openstudio measure -t ./lib/measures >> $GITHUB_WORKSPACE/test_results/measure_check_output.txt

for dir in $(find . -type f \( -name 'measure.rb' -o -name 'measure.py' \) -exec dirname {} \;); do
    openstudio measure --run_tests $dir >> $GITHUB_WORKSPACE/test_results/test_output.txt
    if [ $? -ne 0 ]; then
        echo $dir >> $GITHUB_WORKSPACE/test_results/tests_failed.txt
    fi
done

if [ -f $GITHUB_WORKSPACE/test_results/tests_failed.txt ]; then
    echo "Some tests failed. Check the test output files for details."
else
    echo "All tests passed successfully."
fi