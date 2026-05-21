#!/bin/bash
# Qt5 第三方库安装
# 从 Ubuntu 仓库下载 deb 包，提取到 3rd/qt5/<arch>/

setup_qt5() {
    local arch
    arch=$(get_arch)
    local platform_dir="$THIRD_DIR/qt5/$arch"

    if [ -d "$platform_dir/cmake/Qt5" ]; then
        echo "  -> already installed"
        return 0
    fi

    # 列出所有已安装的 libqt5* 包名用于下载
    local pkgs
    pkgs=$(dpkg -l 'libqt5*' 2>/dev/null | grep '^ii' | awk '{print $2}' | grep -v '\-dev\b' | tr '\n' ' ')
    pkgs="$pkgs qtbase5-dev"

    local tmpdir="$THIRD_DIR/.tmp_qt5"
    rm -rf "$tmpdir"
    mkdir -p "$tmpdir/debs"

    echo "  downloading from Ubuntu repository..."
    cd "$tmpdir/debs"
    apt download $pkgs 2>/dev/null || {
        echo "  ERROR: apt download failed"
        cd "$PROJECT_DIR"
        return 1
    }
    cd "$PROJECT_DIR"

    echo "  extracting..."
    local extracted="$tmpdir/extracted"
    mkdir -p "$extracted"
    for deb in "$tmpdir"/debs/*.deb; do
        dpkg -x "$deb" "$extracted" 2>/dev/null
    done

    local sys_root="$extracted/usr"
    mkdir -p "$platform_dir"

    # 头文件
    if [ -d "$sys_root/include/$arch/qt5" ]; then
        mkdir -p "$platform_dir/include"
        cp -r "$sys_root/include/$arch/qt5"/* "$platform_dir/include/"
    fi

    # cmake 配置
    if [ -d "$sys_root/lib/$arch/cmake" ]; then
        mkdir -p "$platform_dir/cmake/Qt5"
        cp "$sys_root/lib/$arch/cmake/Qt5"/* "$platform_dir/cmake/Qt5/" 2>/dev/null || true
        for dir in "$sys_root/lib/$arch/cmake"/Qt5*; do
            [ -d "$dir" ] && [ "$(basename "$dir")" != "Qt5" ] && cp -r "$dir" "$platform_dir/cmake/"
        done
    fi

    # 动态库
    mkdir -p "$platform_dir/lib"
    find "$sys_root/lib/$arch" -maxdepth 1 -name 'libQt5*.so*' \
        -exec cp -rP {} "$platform_dir/lib/" \; 2>/dev/null || true

    # 插件
    for p in platforms platforminputcontexts imageformats xcbglintegrations; do
        local src="$sys_root/lib/$arch/qt5/plugins/$p"
        if [ -d "$src" ]; then
            mkdir -p "$platform_dir/lib/qt5/plugins/$p"
            cp -r "$src"/* "$platform_dir/lib/qt5/plugins/$p/"
        fi
    done

    # 修复 cmake 路径
    find "$platform_dir/cmake" -type f \( -name "*.cmake" -o -name "*.cmake.in" \) -exec sed -i \
        -e "s|/lib/$arch/|/lib/|g" \
        -e "s|/include/$arch/qt5|/include|g" \
        -e "s|/\.\./\.\./\.\./\.\.|/../..|g" \
        {} +

    rm -rf "$tmpdir"
    echo "  -> done"
}
