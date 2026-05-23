#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR=$PROJECT_DIR/output

case "$(uname -s)" in
    Linux*)   PLATFORM=linux ;;
    MINGW*|MSYS*|CYGWIN*)  PLATFORM=windows ;;
    *)        PLATFORM=unknown ;;
esac

main() {
    case "$1" in
        "build")
            mkdir -p "$PROJECT_DIR/build" && cd "$PROJECT_DIR/build"
            cmake ..
            cmake --build . --parallel || exit 1
            ;;
        "clean")
            rm -rf "$PROJECT_DIR/build" "$OUTPUT_DIR"
            ;;
        "build_and_run")
            mkdir -p "$PROJECT_DIR/build" && cd "$PROJECT_DIR/build"
            cmake ..
            cmake --build . --parallel || exit 1
            if [ "$PLATFORM" = "windows" ]; then
                "$OUTPUT_DIR/mainboard.exe"
            else
                "$OUTPUT_DIR/mainboard"
            fi
            ;;
        "clean_3rd")
            find "$PROJECT_DIR/3rd" -mindepth 1 -maxdepth 1 \
                ! -name 'setup.sh' ! -name 'source' \
                ! -name 'setup.bat' \
                -exec rm -rf {} +
            ;;
        *)
            echo "Usage: $0 {build|clean|build_and_run|clean_3rd}"
            exit 1
            ;;
    esac
}

main "$@"
