# Start with the OpenStudio image
FROM python:3.10

RUN wget https://github.com/NREL/OpenStudio/releases/download/v3.9.0/OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-arm64.tar.gz
    
RUN tar -xvzf OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-arm64.tar.gz

RUN cp -r OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-arm64 /usr/local/openstudio

RUN ls -l

# Set Python 3 as the default Python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Python dependencies
RUN pip install --no-cache-dir pytest openstudio copper-bem constrain

# Set the working directory within the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Find directories containing measure.py and run tests
RUN python run_tests.py

# Inspect the output files for successful and failed tests
CMD find . -name 'pytest_output.txt' -exec cat {} \;