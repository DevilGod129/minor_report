@echo off
setlocal

cd /d "%~dp0"

echo Cleaning LaTeX artifacts in project root...
del /q *.aux *.bbl *.blg *.brf *.fdb_latexmk *.fls *.glo *.gls *.idx *.ilg *.ind *.lof *.log *.lot *.nav *.out *.snm *.synctex.gz *.toc *.acn *.acr *.alg *.dvi *.ps *.pdf 2>nul

if /i "%~1"=="--all" (
    echo Removing versioned output folders...
    for /d %%D in (outputs\report_*) do rd /s /q "%%D"
)

echo ✅ Clean complete.
exit /b 0
