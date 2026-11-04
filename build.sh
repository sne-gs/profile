#!/usr/bin/env sh
#
# Builds the deployable site into dist/:
#
#   dist/index.html        resume.html (English), served at /
#   dist/pt-br.html        resume_pt-br.html (Português), served at /pt-br
#   dist/resume.pdf        PDF, rendered fresh by WeasyPrint
#   dist/resume_pt-br.pdf  PDF, rendered fresh by WeasyPrint
#   dist/fonts/            typefaces embedded via @font-face
#
# Locally: enter the guix shell first (direnv allow / `guix shell`) so that
#          `weasyprint` is on PATH.
# CI:      .forgejo/workflows/deploy.yml installs WeasyPrint, runs this script
#          and deploys dist/ to Cloudflare Pages.

set -eu

if ! command -v weasyprint >/dev/null 2>&1; then
    echo "error: weasyprint not found on PATH." >&2
    echo "       locally: enter the guix shell first (direnv allow / guix shell)" >&2
    echo "       CI: the deploy workflow installs it automatically" >&2
    exit 1
fi

rm -rf dist
mkdir -p dist/fonts

cp -R fonts/. dist/fonts/
cp resume.html dist/index.html
cp resume_pt-br.html dist/pt-br.html

weasyprint resume.html dist/resume.pdf
weasyprint resume_pt-br.html dist/resume_pt-br.pdf

echo
echo "dist/ ready:"
find dist -type f | sort
