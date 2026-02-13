#!/usr/bin/env bash
# Novel Assistant - 一致性检查脚本
# 用途：检查大纲/章节的设定冲突

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# 一致性检查函数
function check_consistency() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "文件不存在: $file"
        return 1
    fi

    print_header "⚠️  一致性检查"

    local project_root=$(get_project_root "$(dirname "$file")")
    if [[ -z "$project_root" ]]; then
        echo "⚠️  未找到项目根目录"
        return 1
    fi

    echo "📍 检查文件: $file"
    echo "📍 项目根: $project_root"
    echo ""

    # 读取文件内容
    local content=$(cat "$file")

    # 检查项目（可扩展）
    local issues=()

    # 1. 检查角色能力一致性
    # TODO: 解析文件，识别角色名，检查能力列表

    # 2. 检查时间线
    # TODO: 解析日期，检查时间线文件

    # 3. 检查地距移动
    # TODO: 识别地点，检查距离合理性

    # 4. 检查世界观冲突
    # TODO: 检查设定是否与世界观一致

    if [[ ${#issues[@]} -eq 0 ]]; then
        echo "✅ 未发现明显冲突"
        return 0
    else
        echo "⚠️  发现 ${#issues[@]} 个潜在问题"
        return 1
    fi
}

# 角色能力检查
function check_character_ability() {
    local character="$1"
    local ability="$2"
    local file="$3"

    # 查找角色卡
    local project_root=$(get_project_root "$(dirname "$file")")
    local character_file="$project_root/docs/characters/$character.md"

    if [[ ! -f "$character_file" ]]; then
        echo "  ⚠️  角色卡不存在: $character"
        return 1
    fi

    # 检查能力列表
    if grep -q "$ability" "$character_file" >/dev/null 2>&1; then
        echo "  ✅ 能力存在于列表中"
        return 0
    else
        echo "  ⚠️  能力不在列表中"
        return 1
    fi
}

# 地点距离检查
function check_distance() {
    local from="$1"
    local to="$2"
    local time="$3"  # 移动时间（小时）

    local distance=100  # TODO: 从地 maps 获取实际距离
    local normal_time=$((distance / 5))  # 步行速度 5km/h

    if [[ $time -lt $normal_time ]]; then
        echo "  ⚠️  移动时间偏短"
        return 1
    fi

    return 0
}

# 主函数
main() {
    if [[ ${BASH_SOURCE[0]} == *"check.sh" ]]; then
        source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
    fi

    check_consistency "$@"
}
