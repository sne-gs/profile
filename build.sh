#!/usr/bin/env sh

set -eu

if command -v weasyprint >/dev/null 2>&1; then
    :
elif python3 -c 'import weasyprint' >/dev/null 2>&1; then
    weasyprint() { python3 -m weasyprint "$@"; }
else
    echo "error: weasyprint is not available." >&2
    echo "       activate the environment that provides it first" >&2
    echo "       (e.g. direnv allow / guix shell), then retry." >&2
    echo "       If this came from the pre-commit hook, you can skip it" >&2
    echo "       with: git commit --no-verify" >&2
    exit 1
fi

weasyprint resume/en-us.html resume/en-us.pdf
weasyprint resume/pt-br.html resume/pt-br.pdf

echo
echo "resume pdfs generated"
