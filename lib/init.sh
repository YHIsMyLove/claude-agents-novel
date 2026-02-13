#!/usr/bin/env bash
# Novel Assistant - 项目初始化脚本
# 用途：创建新的小说项目

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

function init_project() {
    local project_name="$1"
    local genre="${2:-custom}"

    if [[ -z "$project_name" ]]; then
        echo "请提供项目名称"
        return 1
    fi

    # 创建项目目录
    mkdir -p "$project_name"
    cd "$project_name"

    # 创建目录结构
    print_header "📁 创建项目目录"
    mkdir -p docs/{world,characters,items,scenes,timeline,maps}
    mkdir -p outline/{chapters,side-plots}
    mkdir -p chapters/vol-01
    mkdir -p reviews
    mkdir -p logs

    echo "✅ 目录结构创建完成"

    # 复制模板
    print_header "📋 复制项目模板"

    if [[ "$genre" == "xianxia" ]]; then
        cp -r "$CLAUDE_PLUGIN_ROOT/templates/xianxia/novel.md" ./novel.md 2>/dev/null || true
        cp -r "$CLAUDE_PLUGIN_ROOT/templates/xianxia/docs"/* ./docs/ 2>/dev/null || true
    elif [[ "$genre" == "urban" ]]; then
        # TODO: urban template
        cp -r "$CLAUDE_PLUGIN_ROOT/templates/xianxia/novel.md" ./novel.md 2>/dev/null || true
        # 更新 novel.md 中的题材信息
    elif [[ "$genre" == "scifi" ]]; then
        # TODO: scifi template
        cp -r "$CLAUDE_PLUGIN_ROOT/templates/xianxia/novel.md" ./novel.md 2>/dev/null || true
    else
        cp -r "$CLAUDE_PLUGIN_ROOT/templates/xianxia/novel.md" ./novel.md 2>/dev/null || true
    fi

    # 更新项目名称
    if [[ -f "novel.md" ]]; then
        sed -i "s/# \\[小说标题\\]/# $project_name/" novel.md
    fi

    echo "✅ 模板复制完成"

    # 创建初始文件
    print_header "📝 创建初始文件"

    # 世界观索引
    cat > docs/world/INDEX.md << 'EOF'
# 世界观设定索引

## 力量体系
- [ ] [power-system.md](power-system.md) - 修炼体系

## 力力组织
- [ ] [factions.md](factions.md) - 势力组织

## 地理环境
- [ ] [maps.md](maps.md) - 地点和地图

## 历史背景
- [ ] [history.md](history.md) - 世界起源和历史

---

## 使用说明
在 `docs/world/` 中创建详细的世界观设定文件，并在此索引。
EOF

    # 角色索引
    cat > docs/characters/INDEX.md << 'EOF'
# 角色库索引

## 主角
- [ ] [主角](protagonist.md) - 故事主角

## 配角
- [ ] [角色名](character.md) - 配角说明

## 反派
- [ ] [反派名](villain.md) - 反派角色

---

## 使用说明
为每个角色创建独立的 Markdown 文件，使用角色卡模板。
EOF

    # 物品索引
    cat > docs/items/INDEX.md << 'EOF'
# 物品库索引

## 武器
- [ ] [武器名](weapon.md)

## 法宝
- [ ] [法宝名](treasure.md)

## 丹药
- [ ] [丹药名](pill.md)

---

## 使用说明
为重要物品创建独立的 Markdown 文件，记录其属性和剧情作用。
EOF

    # 时间线
    cat > docs/timeline/main.md << 'EOF'
# 时间线 - 主线

## 时间参考
- **当前日期**：故事开始日

## 事件记录
| 日期 | 事件 | 涉及角色 | 地点 | 重要性 |
|------|------|----------|------|--------|
| | | | | |

## 使用说明
记录主线的重要事件和时间节点。
EOF

    # 主线大纲
    cat > outline/main-plot.md << 'EOF'
# 主线大纲

## 故事梗概

[一句话描述你的故事]

## 核心冲突

- [ ] 主角 vs [反派]：冲突描述
- [ ] 主角 vs [反派2]：冲突描述

## 故事走向

1. **开篇**（约XX万字）
   - 主角介绍
   - 激励事件
   - 踏上修行/冒险/创业等道路

2. **发展**（约XX万字）
   - 成长与挑战
   - 世界展开
   - 力力关系变化

3. **高潮**（约XX万字）
   - 大冲突爆发
   - 真相揭晓
   - 最终对决

4. **结局**（约XX万字）
   - 冲突解决
   - 余韵收尾
EOF

    echo "✅ 初始文件创建完成"

    print_divider
    print_header "✅ 项目创建完成"
    echo ""
    echo "项目路径: $(pwd)"
    echo "下一步："
    echo "  1. 完善 docs/ 中的世界观和角色设定"
    echo "  2. 编写 outline/main-plot.md 主线大纲"
    echo "  3. 使用 /novel-assistant:outline 开始编写章节大纲"
    echo ""
    echo "开始写作：/novel-assistant:write"
}

# 主函数
main() {
    if [[ ${BASH_SOURCE[0]} == *"init.sh" ]]; then
        source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
    fi

    init_project "$@"
}
