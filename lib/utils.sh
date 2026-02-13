#!/usr/bin/env bash
# Novel Assistant - 工具函数库
# 提供通用工具函数

# 获取项目根目录
function get_project_root() {
    local current_dir="$1"
    while [[ "$current_dir" != "/" && ! -f "$current_dir/novel.md" ]]; do
        current_dir=$(dirname "$current_dir")
        if [[ -z "$current_dir" ]]; then
            break
        fi
    done
    if [[ -f "$current_dir/novel.md" ]]; then
        echo "$current_dir"
    else
        echo ""
    fi
}

# 统计字数
function count_words() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "0"
        return
    fi

    # 简单的中文字符（排除 markdown 语法）
    local content=$(cat "$file" | sed 's/^\[.*$]//g' | sed 's/^#.*$//g' | sed 's/!\[.*$]//g' | sed 's/!\[.*\]//g' | tr -d '\n' | wc -w)
    echo "$content"
}

# 统计目录下所有文件字数
function count_dir_words() {
    local dir="$1"
    local ext="${2:-md}"
    local total=0

    for file in "$dir"/**/*.$ext"; do
        if [[ -f "$file" ]]; then
            local words=$(count_words "$file")
            total=$((total + words))
        fi
    done

    echo "$total"
}

# 格式化输出标题
function print_header() {
    local title="$1"
    local width=60
    local char="${2:-═}"

    echo ""
    echo "$(printf "$char%.0s" "$width" | tr ' ' ')"
    echo "  $title"
    echo "$(printf "$char%.0s" "$width" | tr ' ' ')"
    echo ""
}

# 格式化输出分隔线
function print_divider() {
    local width=60
    local char="${1:-─}"
    echo "$(printf "$char%.0s" "$width" | tr ' ' ')"
}

# 列断是否在项目目录中
function is_in_project() {
    local root=$(get_project_root "$PWD")
    [[ -n "$root" ]] && [[ -f "$root/novel.md" ]]
}

# 获取项目元数据
function get_novel_meta() {
    local root="$1"
    if [[ -z "$root" ]]; then
        root=$(get_project_root "$PWD")
    fi

    if [[ -f "$root/novel.md" ]]; then
        cat "$root/novel.md"
    else
        echo "# 未找到项目元数据"
    fi
}

# 列出项目状态表格
function print_status_table() {
    local root="$1"
    if [[ -z "$root" ]]; then
        root=$(get_project_root "$PWD")
    fi

    print_header "📊 项目状态"

    # 基本信息
    echo "📁 项目路径: $root"

    # 字数统计
    local total_words=$(count_dir_words "$root/chapters")
    echo "📅 总字数: $total_words 字"

    # 章节进度
    local total_chapters=$(find "$root/chapters" -name "*.md" | wc -l)
    echo "📖 章节进度: $total_chapters 章"

    print_divider
}

# 检查文件编码
function check_encoding() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # 检查是否为 UTF-8
    local encoding=$(file -b "$file" | grep -o 'charset=' | cut -d2 -f2-)
    if [[ "$encoding" != "utf-8" ]]; then
        echo "⚠️  警告: $file 编码不是 UTF-8"
        return 1
    fi

    return 0
}

# 导出文件内容
function export_markdown() {
    local file="$1"
    local dest="${2:-}"

    if [[ ! -f "$file" ]]; then
        echo "文件不存在: $file"
        return 1
    fi

    if [[ -n "$dest" ]]; then
        dest="${file%.md}.export.md"
    fi

    cp "$file" "$dest"
    echo "已导出到: $dest"
}

# 列出进度条
function print_progress_bar() {
    local current=$1
    local total=$2
    local width=40

    if [[ $total -eq 0 ]]; then
        total=1
    fi

    local percent=$((current * 100 / total))
    local filled=$((width * current / total))

    printf "["
    printf -v "#" "%.0s" $filled "" | tr ' ' ' "="
    printf -v " " "%.0s" $((width - filled)) "" | tr ' ' ' "."
    printf "] %d%%" "$percent"
}
