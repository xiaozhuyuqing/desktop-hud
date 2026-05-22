#!/bin/bash
# 第三方库统一安装入口
# 遍历 source/ 下所有 .sh 并执行对应的 setup_<lib> 函数
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
THIRD_DIR="$PROJECT_DIR/3rd"
SOURCE_DIR="$THIRD_DIR/source"

# 颜色
BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
RESET="\033[0m"

get_arch() {
    gcc -print-multiarch 2>/dev/null || uname -m
}

# 加载所有 source/*.sh
_load_sources() {
    for f in "$SOURCE_DIR"/*.sh; do
        [ -f "$f" ] && source "$f"
    done
}

# 列出可用的库
_list() {
    echo "Available libraries:"
    for f in "$SOURCE_DIR"/*.sh; do
        [ -f "$f" ] || continue
        local name
        name=$(basename "$f" .sh)
        echo "  $name"
    done
}

# 安装单个库
_install_one() {
    local name="$1"
    local func="setup_${name//-/_}"
    local script="$SOURCE_DIR/$name.sh"

    if [ ! -f "$script" ]; then
        echo -e "  ${BOLD}$name${RESET}: script not found at $script"
        return 1
    fi

    source "$script"

    if ! declare -f "$func" > /dev/null; then
        echo -e "  ${BOLD}$name${RESET}: function $func not defined"
        return 1
    fi

    echo -e "${BOLD}${CYAN}[$name]${RESET}"
    "$func"
    echo -e "${BOLD}${GREEN}[$name] complete${RESET}\n"
}

main() {
    mkdir -p "$SOURCE_DIR"
    _load_sources

    if [ $# -eq 0 ]; then
        _list
        exit 0
    fi

    local total=$#
    local current=0
    local failed=""

    for name in "$@"; do
        current=$((current + 1))
        echo -e "($current/$total) ${BOLD}$name${RESET}"
        if ! _install_one "$name"; then
            failed="$failed $name"
        fi
    done

    if [ -n "$failed" ]; then
        echo -e "Failed:$failed"
        exit 1
    fi
    echo "All done."
}

main "$@"
