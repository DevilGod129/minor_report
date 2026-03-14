# Minor Project Report

This repository contains our minor project report written in LaTeX.

## Build

- Linux/macOS (bash): `./compile.sh`
- Windows (Command Prompt/PowerShell): `./compile.bat`

Both scripts compile `main.tex` and save output to:

- `outputs/report_v<version>_<yyyy-mm-dd>/main.pdf`

The build version is tracked in `version.txt` and increments on each run.

## Clean

- Linux/macOS (bash): `./clean.sh`
- Windows (Command Prompt/PowerShell): `./clean.bat`

To also remove versioned output folders:

- `./clean.sh --all`
- `./clean.bat --all`

## Structure

- `frontmatter/` contains title page, declaration, certificate, acknowledgement, abstract, and abbreviation pages.
- `chapters/` contains main report chapters.
- `images/` contains image assets.
- `outputs/` contains versioned compiled PDFs from build scripts.
