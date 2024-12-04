#!/usr/bin/env bash

echo $GITHUB_WORKSPACE

openstudio measure -t ./lib/measures >> $GITHUB_WORKSPACE/measure_check_output.txt

for dir in \$(find . -type f -name 'measure.py' -exec dirname {} \; | sort -u); do \
    pytest \$dir >> $GITHUB_WORKSPACE/pytest_output.txt; \
done