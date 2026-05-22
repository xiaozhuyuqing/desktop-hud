#!/bin/bash
# yaml-cpp 第三方库安装
# 从 Ubuntu 仓库下载 deb 包，提取到 3rd/<arch>/yaml-cpp/

setup_yaml_cpp() {
    local arch
    arch=$(get_arch)
    local platform_dir="$THIRD_DIR/$arch/yaml-cpp"

    if [ -d "$platform_dir/include/yaml-cpp" ]; then
        echo "  -> already installed"
        return 0
    fi

    local pkgs="libyaml-cpp-dev libyaml-cpp0.7"

    local tmpdir="$THIRD_DIR/.tmp_yaml-cpp"
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
    if [ -d "$sys_root/include/yaml-cpp" ]; then
        mkdir -p "$platform_dir/include"
        cp -r "$sys_root/include/yaml-cpp" "$platform_dir/include/"
    fi

    # 动态库
    mkdir -p "$platform_dir/lib"
    find "$sys_root/lib/$arch" -maxdepth 1 \( -name 'libyaml-cpp*.so*' -o -name 'libyaml-cpp*.a' \) \
        -exec cp -rP {} "$platform_dir/lib/" \; 2>/dev/null || true

    rm -rf "$tmpdir"
    echo "  -> done"
}
