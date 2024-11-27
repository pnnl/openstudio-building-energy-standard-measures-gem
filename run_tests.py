import os

# Find directories containing measure.py
dirs = set(os.path.dirname(root) for root, _, files in os.walk('.') if 'measure.py' in files)

# Write directories to a file and run tests
with open('/app/python_measure_dirs.txt', 'w') as f:
    for dir in dirs:
        f.write(dir + '\n')
        os.system(f'openstudio measure -t {dir} > {dir}/measure_check_output.txt')
        os.system(f'pytest {dir} > {dir}/pytest_output.txt')