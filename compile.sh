#!/bin/bash

# === CONFIGURATION ===
MAIN_TEX="main.tex"
OUTPUT_DIR="outputs"
VERSION_FILE="version.txt"
DATE=$(date +%Y-%m-%d)
KEEP_BUILDS=5

# === READ & INCREMENT VERSION ===
if [ ! -f "$VERSION_FILE" ]; then
    printf "v1\n" > "$VERSION_FILE"
fi

CURRENT_VERSION=$(tr -d '\r' < "$VERSION_FILE" | xargs)
VERSION_NUM=$(echo "$CURRENT_VERSION" | grep -o '[0-9]\+' | head -n 1)
if [ -z "$VERSION_NUM" ]; then
    CURRENT_VERSION="v1"
    VERSION_NUM=1
fi

NEW_VERSION_NUM=$((VERSION_NUM + 1))
NEW_VERSION="v$NEW_VERSION_NUM"
printf "%s\n" "$NEW_VERSION" > "$VERSION_FILE"

# === OUTPUT FOLDER ===
BUILD_DIR="${OUTPUT_DIR}/report_${CURRENT_VERSION}_${DATE}"
mkdir -p "$BUILD_DIR"

# === COMPILE ===
if ! pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$BUILD_DIR" "$MAIN_TEX"; then
    echo "❌ Build failed on first pdflatex run."
    exit 1
fi

if ! pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$BUILD_DIR" "$MAIN_TEX"; then
    echo "❌ Build failed on second pdflatex run."
    exit 1
fi

# === OUTPUT ===
if [ -f "$BUILD_DIR/main.pdf" ]; then
    echo "✅ Build complete: $BUILD_DIR/main.pdf"
    echo "Next version will be: $NEW_VERSION"

    if [ "$KEEP_BUILDS" -gt 0 ]; then
        OLD_BUILDS=$(ls -1dt "$OUTPUT_DIR"/report_* 2>/dev/null | tail -n +$((KEEP_BUILDS + 1)))
        if [ -n "$OLD_BUILDS" ]; then
            while IFS= read -r old_build; do
                [ -n "$old_build" ] && rm -rf "$old_build"
            done <<< "$OLD_BUILDS"
        fi
    fi
else
    echo "❌ Build failed."
fi
