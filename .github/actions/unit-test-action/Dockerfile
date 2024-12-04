# Start with the OpenStudio image
FROM python:3.10

RUN wget https://github.com/NREL/OpenStudio/releases/download/v3.9.0/OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64.tar.gz && \
    tar -xvzf OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64.tar.gz && \
    cp -r OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64/usr/local/openstudio-3.9.0 /usr/local/openstudio

ENV PATH="/usr/local/openstudio/bin:${PATH}"

# Set Python 3 as the default Python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Python dependencies
RUN pip install --no-cache-dir pytest openstudio copper-bem constrain

# Set the working directory within the container
WORKDIR /github/workspace

# Copy the current directory contents into the container
COPY $GITHUB_WORKSPACE /github/workspace
RUN ls /github/workspace

RUN mkdir /app
COPY . /app
RUN ls /app

RUN mkdir /test
COPY ../../.. /test
RUN ls /test
# Find directories containing measure.py and run tests
RUN ls
RUN mkdir test_results
RUN openstudio measure -t ./lib/measures > test_results/measure_check_output.txt
RUN bash -c "\
    for dir in \$(find . -type f -name 'measure.py' -exec dirname {} \; | sort -u); do \
        pytest \$dir >> test_results/pytest_output.txt; \
    done"