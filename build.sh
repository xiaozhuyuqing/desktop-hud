#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR=$PROJECT_DIR/output

main() {
    case "$1" in
        "build")
            mkdir -p "$PROJECT_DIR/build" && cd "$PROJECT_DIR/build"
            cmake ..
            make -j$(nproc) || exit 1
            ;;
        "clean")
            rm -rf "$PROJECT_DIR/build" "$OUTPUT_DIR"
            ;;
        "build_and_run")
            mkdir -p "$PROJECT_DIR/build" && cd "$PROJECT_DIR/build"
            cmake ..
            make -j$(nproc) || exit 1
            "$OUTPUT_DIR/mainboard"
            ;;
        *)
            echo "Usage: $0 {build|clean|build_and_run}"
            exit 1
            ;;
    esac
}

main "$@"
