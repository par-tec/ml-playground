#!/usr/bin/bash
jupyter lab --no-browser --allow-root --NotebookApp.token="${JUPYTER_TOKEN}" --port="${JUPYTER_PORT:-8080}" --ip=0.0.0.0
