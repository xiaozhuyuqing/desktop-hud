#!/bin/bash

QT_DIR=/home/yuqing/IDE/Qt5.3.2/5.3/gcc_64
PROJECT_DIR=/home/yuqing/code/qt/desktop-hud
OUTPUT_DIR=$PROJECT_DIR/output

main() {
    case "$1" in
        "build")
            mkdir -p $PROJECT_DIR/build && cd $PROJECT_DIR/build
            cmake .. -DCMAKE_PREFIX_PATH=$QT_DIR/lib/cmake \
                -DCUSTOM_TOPDIR=$PROJECT_DIR
            make -j$(nproc) || exit 1
            deploy_qt_libs
            ;;
        "clean")
            rm -rf $PROJECT_DIR/build $OUTPUT_DIR
            ;;
        "build_and_run")
            mkdir -p $PROJECT_DIR/build && cd $PROJECT_DIR/build
            cmake .. -DCMAKE_PREFIX_PATH=$QT_DIR/lib/cmake \
                -DCUSTOM_TOPDIR=$PROJECT_DIR
            make -j$(nproc) || exit 1
            deploy_qt_libs
            $OUTPUT_DIR/mainboard
            ;;
        *)
            echo "Usage: $0 {build|clean|build_and_run}"
            exit 1
            ;;
    esac
}

deploy_qt_libs() {
    local exe=$OUTPUT_DIR/mainboard
    local qt_lib_dir=$QT_DIR/lib
    local qt_plugin_dir=$QT_DIR/plugins

    for lib in $(ldd "$exe" | grep -oP "$qt_lib_dir/\S+" | sort -u); do
        cp -v "$lib" "$OUTPUT_DIR/"
    done

    mkdir -p "$OUTPUT_DIR/platforms"
    cp -v "$qt_plugin_dir"/platforms/libqxcb.so "$OUTPUT_DIR/platforms/"
}

main $@
