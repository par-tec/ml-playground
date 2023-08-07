#
# Development Dockerfile, featuring:
#  - Debian development environment
#
# Build with:
#
# $ docker build -f py310-debian.dockerfile  .
#
FROM docker.io/library/python:3.10 as baseimage

RUN apt-get update
RUN mkdir /tools
RUN pip3 install --upgrade pip

COPY ./requirements.txt ./requirements-dev.txt /tools/

RUN --mount=type=cache,target=/wheels \
    pip wheel -w /wheels --prefer-binary \
    --no-cache-dir \
    -r /tools/requirements.txt \
    -r /tools/requirements-dev.txt
RUN --mount=type=cache,target=/wheels \
    pip install --find-links /wheels --no-index --prefer-binary \
    --no-cache-dir \
    -r /tools/requirements.txt \
    -r /tools/requirements-dev.txt
RUN --mount=type=cache,target=/wheels cp -r /wheels /tools/wheels

USER 1001
