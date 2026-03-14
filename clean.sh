#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "Cleaning LaTeX artifacts in project root..."
rm -f *.aux *.bbl *.blg *.brf *.fdb_latexmk *.fls *.glo *.gls *.idx *.ilg *.ind *.lof *.log *.lot *.nav *.out *.snm *.synctex.gz *.toc *.acn *.acr *.alg *.dvi *.ps *.pdf

if [[ "${1:-}" == "--all" ]]; then
  echo "Removing versioned output folders..."
  rm -rf outputs/report_*
fi

echo "✅ Clean complete."
