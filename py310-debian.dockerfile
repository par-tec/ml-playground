#
# Development Dockerfile, featuring:
#  - Debian development environment
#
# Build with:
#
# $ docker build -f py310-debian.dockerfile  .
#
FROM docker.io/library/python:3.10 as baseimage

ARG FLAVOR=debian
ARG PIP_ARGS="--no-cache-dir --prefer-binary"
RUN apt-get update && \
    apt-get install -y libgl-dev libgl1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /tools
RUN pip3 install --upgrade pip

COPY ./requirements.${FLAVOR}.txt ./requirements-dev.txt /tools/


RUN --mount=type=cache,target=/wheels \
    pip wheel -w /wheels ${PIP_ARGS} \
    -r /tools/requirements.${FLAVOR}.txt \
    -r /tools/requirements-dev.txt
RUN --mount=type=cache,target=/wheels \
    pip install --find-links /wheels --no-index ${PIP_ARGS} \
    -r /tools/requirements.${FLAVOR}.txt \
    -r /tools/requirements-dev.txt
RUN --mount=type=cache,target=/wheels cp -r /wheels /tools/wheels

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
EXPOSE 8080
VOLUME [ "/home/jupyter" ]
WORKDIR /home/jupyter
RUN useradd -u 1000 -s /bin/bash -g 0 jupyter
USER 1000
