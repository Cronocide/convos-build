FROM python:3.12 AS python
ENV PROJ_NAME=python-tool

# Copy project files
ADD ./ /$PROJ_NAME
# Install module
# RUN python3 -m pip install -e /$PROJ_NAME


# Run entrypoint
ENTRYPOINT ["/usr/local/bin/python-tool"]
