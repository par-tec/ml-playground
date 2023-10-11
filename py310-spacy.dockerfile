#
# Development Dockerfile, featuring:
#  - Debian development environment
#
# Build with:
#
# $ docker build -f py310-spacy.dockerfile  .
#
# Use alternative image when building from GCP
# - europe-west12-docker.pkg.dev/$PROJECT_ID/$_REGISTRY_ID/ml-playground
#
ARG BASEIMAGE=ghcr.io/par-tec/ml-playground

FROM ${BASEIMAGE}:py310-debian

USER root
ARG FLAVOR=spacy

#
# Spacy
#
ENV models="en_core_web_sm it_core_news_sm  it_core_news_md  it_core_news_lg"
ARG PIP_ARGS="--no-cache-dir --prefer-binary"
ENV PIP_NO_CACHE_DIR=1

COPY ./requirements.debian.txt \
    ./requirements.${FLAVOR}.txt \
    ./requirements-dev.txt /tools/

RUN --mount=type=cache,target=/wheels \
    pip wheel -w /wheels ${PIP_ARGS} \
    -r /tools/requirements.${FLAVOR}.txt \
    -r /tools/requirements-dev.txt

RUN --mount=type=cache,target=/wheels \
    pip install --find-links /wheels --no-index ${PIP_ARGS} \
    -r /tools/requirements.${FLAVOR}.txt \
    -r /tools/requirements-dev.txt

RUN --mount=type=cache,target=/wheels \
    for model in ${models}; do \
        python -m spacy download ${model}; \
    done

USER 1000
