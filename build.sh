#!/usr/bin/env bash
set -euo pipefail

# Build resume PDF using md2pdf's official Docker image
docker run --rm -t \
  -v "$PWD:/wrk" \
  -u "$(id -u):$(id -g)" \
  -w /wrk \
  jmaupetit/md2pdf:latest \
  -i resume.md -o resume.pdf

echo "resume.pdf generated"
