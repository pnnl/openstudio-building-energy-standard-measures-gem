FROM python:3.12

RUN wget https://github.com/NREL/OpenStudio/releases/download/v3.9.0/OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64.tar.gz && \
    tar -xvzf OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64.tar.gz && \
    cp -r OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64/usr/local/openstudio-3.9.0 /usr/local/openstudio && \
    rm -rf OpenStudio-3.9.0+c77fbb9569-Ubuntu-22.04-x86_64.tar.gz

ENV PATH="/usr/local/openstudio/bin:${PATH}"

# Set the working directory within the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r ./requirements.txt

# Find directories containing measure.py and run tests'
ENTRYPOINT ["./entrypoint.sh"]