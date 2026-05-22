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
        "clean_3rd")
            find "$PROJECT_DIR/3rd" -mindepth 1 -maxdepth 1 \
                ! -name 'setup.sh' ! -name 'source' \
                -exec rm -rf {} +
            ;;
        *)
            echo "Usage: $0 {build|clean|build_and_run|clean_3rd}"
            exit 1
            ;;
    esac
}

main "$@"
